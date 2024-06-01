//
//  HTMLDocument+parse.swift
//
//
//  Created by Danny Pang on 2022/7/4.
//

extension Document {
    public func parse<Output>(_ html: HTML<Output>, debug: Bool = false) throws -> Output {
        try rootElement.parse(html, debug: debug)
    }
    
    public func parse<Output>(_ html: HTML<Output>) async throws -> Output {
        try await rootElement.parse(html)
    }
    
    public func parse<Component: HTMLComponent>(
        @HTMLComponentBuilder component: () -> Component
    ) throws -> Component.HTMLOutput {
        let html = component().html
        return try parse(html)
    }
}

extension Element {
    public func parse<Output>(_ html: HTML<Output>, debug: Bool = false) throws -> Output {
        let result = try HTMLDecodeImpl.parse(html.node, element: self, debug ? 0 : nil)
        
        //if debug { print("array:", result) }
        
        if result.count == 1 {
            return result[0] as! Output
        } else {
            return TypeConstruction.tuple(of: result) as! Output
        }
    }
    
    public func parse<Output>(_ html: HTML<Output>) async throws -> Output {
        let result = try await HTMLDecodeImpl.parseAsync(html.node, element: self)
        
        if result.count == 1 {
            return result[0] as! Output
        } else {
            return TypeConstruction.tuple(of: result) as! Output
        }
    }
}

public enum HTMLParseError: Error {
    case cantFindElement(selector: String)
    case description(String)
}

struct HTMLDecodeImpl {
    static func parse(_ node: DSLTree.Node, element: any Element, _ indent: Int? = nil) throws -> [Any] {
        var next: Int?
        if let indent {
            print(String(repeating: " ", count: indent), node.description)
            next = indent + 4
        }
        
        switch node {
        case .concatenation(let array):
            var buffer = [Any]()
            buffer.reserveCapacity(array.count)
            for node in array {
                buffer += try parse(node, element: element, next)
            }
            return buffer
        case .capture(let selector, let transform):
            let e = try element.querySelector(selector)
                .orThrow(HTMLParseError.cantFindElement(selector: selector))
            if let transform {
                if let function = try transform.callAsFunction(e) {
                    return [function]
                } else {
                    return []
                }
            } else {
                return [e]
            }
        case .tryCapture(let selector, let transform):
            let e = element.querySelector(selector)
            let function = try? transform.callAsFunction(e)
            return [function as Any]
        case .captureAll(let selector, let transform):
            let elements: [any Element] = element.querySelectorAll(selector)
            if let transform {
                /*
                 var buffer = [Any]()
                 for element in elements {
                     let function = try transform.callAsFunction(element)
                     buffer.append(function as Any)
                 }
                 result = buffer
                 */
                let function = try transform.callAsFunction(elements) as Any
                return [function]
            } else {
                return [elements]
            }
        /*
        case ._captureAll(let selector, let child):
            var buffer = [Any]()
            let elements = element.querySelectorAll(selector)
            for element in elements {
                let r = try _parse(child, element: element, next)
                buffer.append(r)
            }
            result = [buffer]
         */
        case .local(let selector, let child, let transform):
            let e: any Element
            if selector.isEmpty {
                e = element
            } else {
                e = try element.querySelector(selector)
                    .orThrow(HTMLParseError.cantFindElement(selector: selector))
            }
            if let transform {
                let r: [Any] = try parse(child, element: e, next)
                let tuple = constructTuple(r)
                let function = try transform.callAsFunction(tuple) as Any
                return [function]
            } else {
                let result = try parse(child, element: e, next)
                if result.count == 1 {
                    return [result[0]]
                } else {
                    return [TypeConstruction.tuple(of: result)]
                }
            }
        case .root(let child, let transform):
            let r: [Any] = try parse(child, element: element, next)
            let tuple = constructTuple(r)
            return [try transform.callAsFunction(tuple) as Any]
//            if r.count == 1 {
//                result = [try transform.callAsFunction(r[0]) as Any]
//            } else if r.count > 1 {
//                let tuple = TypeConstruction.tuple(of: r)
//                result = [try transform.callAsFunction(tuple) as Any]
//            }
        case .empty:
            return []
        }
    }
    
    static func parseAsync(_ node: DSLTree.Node, element: any Element) async throws -> [Any] {
        
        switch node {
        case .concatenation(let array):
            return try await withThrowingTaskGroup(of: (Int, [Any]).self) { (group) -> [Any] in
                var result = [Any]()
                var orderTable = [Int: [Any]]()
                let count = array.count
                result.reserveCapacity(count)
                orderTable.reserveCapacity(count)
                
                for (i, node) in array.enumerated() {
                    group.addTask {
                        let result = try await parseAsync(node, element: element)
                        return (i, result)
                    }
                }
                for try await node in group {
                    orderTable[node.0] = node.1
                }
                for key in 0..<count {
                    result += orderTable[key]!
                }
                return result
            }
        case .capture(let selector, let transform):
            let e = try element.querySelector(selector)
                .orThrow(HTMLParseError.cantFindElement(selector: selector))
            if let transform {
                if let function = try transform.callAsFunction(e) {
                    return [function]
                } else {
                    return []
                }
            } else {
                return [e]
            }
        case .tryCapture(let selector, let transform):
            let e = element.querySelector(selector)
            let function = try? transform.callAsFunction(e)
            return [function as Any]
        case .captureAll(let selector, let transform):
            let elements: [any Element] = element.querySelectorAll(selector)
            if let transform {
                let function = try transform.callAsFunction(elements) as Any
                return [function]
            } else {
                return [elements]
            }
        case .local(let selector, let child, let transform):
            let e: any Element
            if selector.isEmpty {
                e = element
            } else {
                e = try element.querySelector(selector)
                    .orThrow(HTMLParseError.cantFindElement(selector: selector))
            }
            if let transform {
                let r: [Any] = try await parseAsync(child, element: e)
                let tuple = constructTuple(r)
                return [try transform.callAsFunction(tuple) as Any]
            } else {
                let result = try await parseAsync(child, element: e)
                if result.count == 1 {
                    return [result[0]]
                } else {
                    return [TypeConstruction.tuple(of: result)]
                }
            }
        case .root(let child, let transform):
            let r: [Any] = try await parseAsync(child, element: element)
            let tuple = constructTuple(r)
            return [try transform.callAsFunction(tuple) as Any]
        case .empty:
            return []
        }
    }
    
    private static func constructTuple(_ x: [Any]) -> Any {
        if x.count > 1 {
            return TypeConstruction.tuple(of: x)
        } else {
            return x[0]
        }
    }
    
    private static func traversalTypeConstruct(_ x: Any) -> Any {
        guard let x = x as? [[Any]] else {
            if let y = x as? [Any] {
                return constructTuple(y)
            } else {
                return x
            }
        }
        
        let y = x.map {
            return traversalTypeConstruct($0)
        }
        return y
    }
}

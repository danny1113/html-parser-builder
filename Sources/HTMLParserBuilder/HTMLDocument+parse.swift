//
//  HTMLDocument+parse.swift
//  
//
//  Created by Danny Pang on 2022/7/4.
//

import HTMLKit


extension HTMLDocument {
    public func parse<Output>(_ html: HTML<Output>, debug: Bool = false) throws -> Output {
        guard let rootElement = rootElement else {
            throw HTMLParseError.cantFindElement(selector: "body")
        }
        
        let result = try HTMLDecodeFunction()._parse(html.node, element: rootElement, debug ? 0 : nil)
        
        // if debug { print("array:", result) }
        
        if result.count == 1 {
            return result[0] as! Output
        } else {
            return TypeConstruction.tuple(of: result) as! Output
        }
    }
    
    public func parse<Component: HTMLComponent>(
        @HTMLComponentBuilder component: () -> Component
    ) throws -> Component.HTMLOutput {
        guard let rootElement = rootElement else {
            throw HTMLParseError.cantFindElement(selector: "body")
        }
        
        let html = component().html
        let result = try HTMLDecodeFunction()._parse(html.node, element: rootElement)
        
        if result.count == 1 {
            return result[0] as! Component.HTMLOutput
        } else {
            return TypeConstruction.tuple(of: result) as! Component.HTMLOutput
        }
    }
}

extension HTMLElement {
    public func parse<Output>(_ html: HTML<Output>, debug: Bool = false) throws -> Output {
        let result = try HTMLDecodeFunction()._parse(html.node, element: self, debug ? 0 : nil)
        
        // if debug { print("array:", result) }
        
        if result.count == 1 {
            return result[0] as! Output
        } else {
            return TypeConstruction.tuple(of: result) as! Output
        }
    }
}

extension HTMLDocument {
    public func _querySelector(_ selector: String) throws -> HTMLElement {
        return try querySelector(selector)
            .orThrow(HTMLParseError.cantFindElement(selector: selector))
    }
}

extension HTMLElement {
    public func _querySelector(_ selector: String) throws -> HTMLElement {
        return try querySelector(selector)
            .orThrow(HTMLParseError.cantFindElement(selector: selector))
    }
}

public enum HTMLParseError: Error {
    case cantFindElement(selector: String)
    case description(String)
}

struct HTMLDecodeFunction {
    func _parse(_ node: DSLTree.Node, element: HTMLElement, _ indent: Int? = nil) throws -> [Any] {
        var next: Int?
        if let indent {
            print(String(repeating: " ", count: indent), node.description)
            next = indent + 4
        }
        var result = [Any]()
        
        switch node {
        case .concatenation(let array):
            for node in array {
                result += try _parse(node, element: element, next)
            }
        case .capture(let selector, let transform):
            let e = try element._querySelector(selector)
            if let transform {
                if let function = try transform.callAsFunction(e) {
                    result.append(function)
                }
            } else {
                result.append(e)
            }
        case .tryCapture(let selector, let transform):
            let e = element.querySelector(selector)
            let function = try? transform.callAsFunction(e)
            result.append(function as Any)
        case .captureAll(let selector, let transform):
            let elements: [HTMLElement] = element.querySelectorAll(selector)
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
                result.append(function)
            } else {
                result.append(elements)
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
            let e: HTMLElement
            if selector.isEmpty {
                e = element
            } else {
                e = try element._querySelector(selector)
            }
            if let transform {
                let r: [Any] = try _parse(child, element: e, next)
                let tuple = constructTuple(r)
                result = [try transform.callAsFunction(tuple) as Any]
            } else {
                result = try _parse(child, element: e, next)
            }
        case .root(let child, let transform):
            let r: [Any] = try _parse(child, element: element, next)
            let tuple = constructTuple(r)
            result = [try transform.callAsFunction(tuple) as Any]
//            if r.count == 1 {
//                result = [try transform.callAsFunction(r[0]) as Any]
//            } else if r.count > 1 {
//                let tuple = TypeConstruction.tuple(of: r)
//                result = [try transform.callAsFunction(tuple) as Any]
//            }
        case .empty:
            return []
        }
        
        return result
    }
    
    private func constructTuple(_ x: [Any]) -> Any {
        if x.count > 1 {
            return TypeConstruction.tuple(of: x)
        } else {
            return x[0]
        }
    }
    
    private func traversalTypeConstruct(_ x: Any) -> Any {
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
    
    
    /*
    func parse(_ node: DSLTree.Node, element: HTMLElement) throws -> [Any] {
        let result: [Any]
        switch node {
        case .concatenation(let array):
            var buffer = [Any]()
            for node in array {
                buffer.append(try parse(node, element: element))
            }
            result = buffer
        case .capture(let selector, let transform):
            let e = try element._querySelector(selector)
            if let transform {
                if let function = try transform.callAsFunction(e) {
                    result = [function]
                } else {
                    result = []
                }
            } else {
                result = [e]
            }
        case .tryCapture(let selector, let transform):
            guard let e = element.querySelector(selector) else {
                result = [try transform.callAsFunction(HTMLElement(tagName: "body")) as Any]
                break
            }
            if let function = try transform.callAsFunction(e) {
                result = [function]
            } else {
                result = []
            }
        case .captureAll(let selector, let transform):
            let elements: [HTMLElement] = element.querySelectorAll(selector)
            if let transform {
                if let function = try transform.callAsFunction(elements),
                    let anyArray = function as? [Any] {
                    print("anyArray", anyArray)
                    result = anyArray
                } else {
                    result = []
                }
            } else {
                result = elements
            }
        case ._captureAll(let selector, let child):
            result = []
        case .local(let selector, let child, let transform):
            let e = try element._querySelector(selector)
            result = try parse(child, element: e)
        case .root(let child, let transform):
            result = []
        case .empty:
            result = []
        }
        
        return result
    }
     */
}

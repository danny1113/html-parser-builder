//
//  HTMLDocument+parse.swift
//
//
//  Created by Danny Pang on 2022/7/4.
//

extension Document {
    public func parse<Output>(_ html: HTML<Output>, debug: Bool = false) throws
        -> Output
    {
        try rootElement.parse(html, debug: debug)
    }

    public func parse<Component: HTMLComponent>(
        @HTMLComponentBuilder component: () -> Component
    ) throws -> Component.HTMLOutput {
        let html = component().html
        return try parse(html)
    }
}

extension Element {
    public func parse<Output>(_ html: HTML<Output>, debug: Bool = false) throws
        -> Output
    {
        let result = try HTMLDecodeImpl.parse(
            html.node, element: self, debug ? 0 : nil)

        //if debug { print("array:", result) }

        if result.count == 1 {
            return result[0] as! Output
        } else {
            return TypeConstruction.tuple(of: result) as! Output
        }
    }
}

struct HTMLDecodeImpl {
    static func parse(
        _ node: DSLTree.Node, element: any Element, _ indent: Int? = nil
    ) throws -> [Any] {
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
        case .one(let selector, let transform):
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
        case .zeroOrOne(let selector, let transform):
            let e = element.querySelector(selector)
            let function = try? transform.callAsFunction(e)
            return [function as Any]
        case .many(let selector, let transform):
            let elements: [any Element] = element.querySelectorAll(selector)
            if let transform {
                let function = try transform.callAsFunction(elements) as Any
                return [function]
            } else {
                return [elements]
            }
        case .group(let selector, let child, let transform):
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
}

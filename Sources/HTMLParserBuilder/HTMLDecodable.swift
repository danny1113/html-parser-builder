//
//  HTMLDecodable.swift
//
//
//  Created by Danny Pang on 2022/7/5.
//

public protocol HTMLDecodable<Decoder> {
    associatedtype Decoder: HTMLDecoder
    
    init(from document: Decoder) throws
}


public protocol HTMLDecoder {
    associatedtype Element
    
    func querySelector(_ selector: String) -> Element?
    func querySelectorAll(_ selector: String) -> [Element]
}

public extension HTMLDecoder {
    func decode<T>(as type: T.Type) throws -> T where T: HTMLDecodable, T.Decoder == Self {
        return try T(from: self)
    }
    
    func _querySelector(_ selector: String) throws -> Element {
        return try querySelector(selector)
            .orThrow(HTMLParseError.cantFindElement(selector: selector))
    }
    
    func getElementById(_ id: String) -> Element? {
        return querySelector("#" + id)
    }
    
    func getElementsByClassName(_ className: String) -> [Element] {
        return querySelectorAll("." + className)
    }
    
    func getElementsByTagName(_ tagName: String) -> [Element] {
        return querySelectorAll(tagName)
    }
}


extension HTMLDocument: HTMLDecoder {
    
}

extension HTMLElement: HTMLDecoder {
    
}

//
//  HTMLParserBuilder.swift
//
//
//  Created by Danny Pang on 2022/7/2.
//

/// A type that holds the HTML DOM representation.
public protocol Document {
    associatedtype E: Element

    var rootElement: E? { get }
}

/// A type that represents part of a HTML DOM element.
public protocol Element {
    var textContent: String { get }

    var innerHTML: String { get }
    var outerHTML: String { get }

    var id: String? { get }

    var className: String { get }
    var classList: [String] { get }

    var attributes: [String: String] { get }

    func hasAttribute(_ attribute: String) -> Bool

    subscript(_ key: String) -> String? { get }

    func querySelector(_ selector: String) -> Self?
    func querySelector(_ selector: String) throws -> Self
    func querySelectorAll(_ selector: String) -> [Self]

    func getElementById(_ id: String) -> Self?
    func getElementsByClassName(_ className: String) -> [Self]
    func getElementsByTagName(_ tagName: String) -> [Self]
}

extension Element {
    public func querySelector(_ selector: String) throws -> Self {
        try self.querySelector(selector)
            .orThrow(HTMLParseError.cantFindElement(selector: selector))
    }

    @inlinable
    public func getElementById(_ id: String) -> Self? {
        return querySelector("#" + id)
    }

    @inlinable
    public func getElementsByClassName(_ className: String) -> [Self] {
        return querySelectorAll("." + className)
    }

    @inlinable
    public func getElementsByTagName(_ tagName: String) -> [Self] {
        return querySelectorAll(tagName)
    }
}

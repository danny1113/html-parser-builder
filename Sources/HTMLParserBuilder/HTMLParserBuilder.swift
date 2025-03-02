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

    /// Get the attribute with key.
    subscript(_ key: String) -> String? { get }

    /// Same as `querySelector`.
    ///
    /// Using this is the same as using `querySelector`,
    /// you pass the selector you want to query,
    /// it retuns the first element that match the selector.
    ///
    /// - Parameter selector: the selector you want to query.
    /// - Returns: The first element that match the selector.
    func query(selector: String) throws -> Self

    /// Same as `querySelectorAll`.
    ///
    /// Using this is the same as using `querySelectorAll`,
    /// you pass the selector you want to query,
    /// it returns all the elements that match the selector.
    ///
    /// - Parameter selector: the selector you want to query.
    ///- Returns: All the elements that match the selector.
    func queryAll(selector: String) -> [Self]
}

extension Document {
    @inlinable
    public func parse<Output>(
        _ html: borrowing HTML<Output>
    ) throws -> Output {
        guard let rootElement else {
            throw HTMLParseError.description("rootElement is nil")
        }
        return try html.parse(from: rootElement)
    }
}

extension Element {
    @inlinable
    public func parse<Output>(
        _ html: borrowing HTML<Output>
    ) throws -> Output {
        try html.parse(from: self)
    }
}

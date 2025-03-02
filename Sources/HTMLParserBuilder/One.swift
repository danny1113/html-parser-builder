//
//  One.swift
//
//
//  Created by Danny Pang on 2022/7/2.
//

/// Capture the first element that matches the CSS selector.
///
/// This will throws an error if no element match the CSS selector,
/// if you want to returns an optional element, see ``ZeroOrOne``.
///
/// To returns a first element that matches the selector #selector:
/// ```swift
/// One("#selector")
/// ```
///
/// You can also get properties from an element by provide a transform closure:
/// ```swift
/// One("#selector", transform: \.textContent)
/// One("#selector") { (e: (any Element)) in
///     return e.textContent
/// }
/// ```
@frozen
public struct One<Output>: Sendable, HTMLComponent {

    private let selector: String
    private let transform: @Sendable (any Element) throws -> Output

    public init(_ selector: String) where Output == any Element {
        self.selector = selector
        self.transform = { e in e }
    }

    public init(
        _ selector: String,
        transform: @Sendable @escaping (any Element) throws -> Output
    ) {
        self.selector = selector
        self.transform = transform
    }

    public func parse(from element: some Element) throws -> Output {
        let e = try element.query(selector: selector)
        return try transform(e)
    }
}

//
//  ZeroOrOne.swift
//
//
//  Created by Danny Pang on 2022/7/9.
//

/// Try to capture the first element that matches the CSS selector.
///
/// This will return an optional element, if you want to throws an error when no element match the CSS selector, see ``Capture``.
///
/// To returns a first element that matches the selector #selector:
/// ```swift
/// ZeroOrOne("#selector")
/// ```
///
/// You can also get properties from an element by provide a transform closure:
/// ```swift
/// ZeroOrOne("#selector", transform: \.?.textContent)
/// ZeroOrOne("#selector") { (e: (any Element)?) -> String? in
///     return e?.textContent
/// }
/// ```
@frozen
public struct ZeroOrOne<Output>: Sendable, HTMLComponent {

    private let selector: String
    private let transform: @Sendable ((any Element)?) throws -> Output

    public init(_ selector: String) where Output == (any Element)? {
        self.selector = selector
        self.transform = { e in e }
    }

    public init(
        _ selector: String,
        transform: @Sendable @escaping ((any Element)?) throws -> Output
    ) {
        self.selector = selector
        self.transform = transform
    }

    public func parse(from element: any Element) throws -> Output {
        let e = try? element.querySelector(selector)
        return try transform(e)
    }
}

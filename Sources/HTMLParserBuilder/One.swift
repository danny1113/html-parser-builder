//
//  One.swift
//
//
//  Created by Danny Pang on 2022/7/2.
//

/// Capture the first element that matches the CSS selector.
///
/// This will throws an error if no element match the CSS selector, if you want to returns an optional element, see ``ZeroOrOne``.
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
public struct One<Output>: Sendable, HTMLComponent {

    public let html: HTML<Output>

    public init(
        _ selector: String,
        transform: @Sendable @escaping (any Element) throws -> Output
    ) {
        self.html = .init(
            node: .one(
                selector: selector,
                transform: CaptureTransform(transform)
            ))
    }

    public init(_ selector: String) where Output == any Element {
        self.html = .init(node: .one(selector: selector))
    }
}

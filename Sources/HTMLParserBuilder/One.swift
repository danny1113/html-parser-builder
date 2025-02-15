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

    private let selector: String
    private let _transform: @Sendable (any Element) throws -> Output

    public init(_ selector: String) where Output == any Element {
        self.selector = selector
        self._transform = { e in e }
    }

    public init(
        _ selector: String,
        transform: @Sendable @escaping (any Element) throws -> Output
    ) {
        self.selector = selector
        self._transform = transform
    }

    public consuming func map<NewOutput>(
        _ f: @Sendable @escaping (Output) throws -> NewOutput
    ) -> One<NewOutput> {
        let transform = _transform
        return .init(selector) { e in
            let output = try transform(e)
            return try f(output)
        }
    }

    public func parse(from element: any Element) throws -> Output {
        let e = try element.querySelector(selector)
            .orThrow(HTMLParseError.cantFindElement(selector: selector))
        return try _transform(e)
    }
}

//
//  Group.swift
//
//
//  Created by Danny Pang on 2022/7/9.
//

/// A local scope that find the first element that matches the CSS selector first,
/// than find all the elements inside based on the local scope.
///
/// The example below captures the first element with the "h1" tag inside the element with the id "group".
///
/// ```swift
/// Group("#group") {
///     One("h1", transform: \.textContent)
/// }
/// ```
public struct Group<Output>: Sendable, HTMLComponent {

    private let selector: String
    private let _parse: @Sendable (any Element) throws -> Output

    private init(
        selector: String,
        parse: @Sendable @escaping (any Element) throws -> Output
    ) {
        self.selector = selector
        self._parse = parse
    }

    public init(
        _ selector: String,
        @HTMLComponentBuilder
        component: () -> HTML<Output>
    ) {
        self.selector = selector
        let html = component()
        self._parse = { element in
            let e = try element.querySelector(selector)
                .orThrow(HTMLParseError.cantFindElement(selector: selector))
            return try html.parse(from: e)
        }
    }

    consuming func map<NewOutput>(
        _ f: @Sendable @escaping (Output) throws -> NewOutput
    ) -> Group<NewOutput> {
        let parse = self._parse
        return .init(selector: selector) { e in
            let output = try parse(e)
            return try f(output)
        }
    }

    public func parse(from element: any Element) throws -> Output {
        return try _parse(element)
    }
}

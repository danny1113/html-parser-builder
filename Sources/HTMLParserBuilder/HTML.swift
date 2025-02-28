//
//  HTML.swift
//
//
//  Created by Danny Pang on 2022/7/2.
//

/// Top level building block for creating a parser builder.
///
/// The example below shows how to build a html parser:
///
/// ```swift
/// let capture: HTML<(String?, (String, String))> = HTML {
///     ZeroOrOne("#hello") { (element: any Element?) -> String? in
///         return element?.textContent
///     } // => HTML<String?>
///
///     Group("#group") {
///         One("h1", transform: \.textContent)
///         One("h2", transform: \.textContent)
///     } // => HTML<(String, String)>
/// }
///
/// let htmlString = "<html>...</html>"
/// let doc: any Document = HTMLDocument(string: htmlString)
///
/// let output: (String?, (String, String)) = try doc.parse(capture)
/// ```
///
/// For more information about other building blocks to build a html parser,
/// see ``One``, ``ZeroOrOne``, ``Group``.
@frozen
public struct HTML<Output>: Sendable, HTMLComponent {

    private let _parse: @Sendable (any Element) throws -> Output

    private init(
        parse: @Sendable @escaping (any Element) throws -> Output
    ) {
        self._parse = parse
    }

    public init(
        @HTMLComponentBuilder
        component: () -> HTML<Output>
    ) {
        self = component()
    }

    init<each Component: HTMLComponent>(
        component: (repeat each Component)
    ) where Output == (repeat (each Component).Output) {
        self._parse = { e in
            return try (repeat (each component).parse(from: e))
        }
    }

    public consuming func map<NewOutput>(
        _ transform: @Sendable @escaping (Output) throws -> NewOutput
    ) -> HTML<NewOutput> {
        let parse = self._parse
        return .init { e in
            let output = try parse(e)
            return try transform(output)
        }
    }

    public func parse(from element: any Element) throws -> Output {
        try _parse(element)
    }
}

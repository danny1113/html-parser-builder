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
/// ```html
/// <div id="group">
///     <h1>hi</h1>
///     <h2>there</h2>
/// </div>
/// ```
///
/// ```swift
/// let parser: HTML<(String?, (String, String))> = HTML {
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
/// let doc = HTMLDocument(string: htmlString)
///
/// let output: (String?, (String, String)) = try doc.parse(parser)
/// // output: (nil, "hi", "there")
/// ```
///
/// For more information about other building blocks to build a html parser,
/// see ``One``, ``ZeroOrOne``, ``Group``, ``Many``.
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

    /// Transform to a new output type with the given closure
    ///
    /// The example below transform output to a custom type `Pair`:
    ///
    /// ```swift
    /// struct Pair {
    ///     let h1, h2: String
    /// }
    ///
    /// let parser: HTML<Pair> = HTML {
    ///     One("h1", transform: \.textContent)
    ///     One("h2", transform: \.textContent)
    /// }
    /// .map { output -> Pair in
    ///     Pair(h1: output.1, h2: output.2)
    /// }
    /// ```
    public consuming func map<NewOutput>(
        _ transform: @Sendable @escaping (Output) throws -> NewOutput
    ) -> HTML<NewOutput> {
        let parse = self._parse
        return .init { e in
            let output = try parse(e)
            return try transform(output)
        }
    }

    public func parse(from element: some Element) throws -> Output {
        try _parse(element)
    }
}

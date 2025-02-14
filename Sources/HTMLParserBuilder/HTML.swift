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
public struct HTML<Output>: Sendable, HTMLComponent {

    let node: DSLTree.Node

    public var html: HTML<Output> {
        self
    }

    init(node: DSLTree.Node) {
        self.node = node
    }

    public init<Component: HTMLComponent>(
        @HTMLComponentBuilder _ component: () -> Component
    ) where Output == Component.HTMLOutput {
        self = component().html
    }

    public init<Component: HTMLComponent>(
        @HTMLComponentBuilder _ component: () -> Component,
        transform: @Sendable @escaping (Component.HTMLOutput) throws -> Output
    ) {
        let html = component().html
        self.node = .root(
            child: html.node,
            transform: CaptureTransform(transform)
        )
    }
}

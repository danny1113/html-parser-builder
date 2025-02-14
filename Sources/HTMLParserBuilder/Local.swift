//
//  Local.swift
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
/// Local("#group") {
///     Capture("h1", transform: \.textContent)
/// }
/// ```
public struct Local<Output>: Sendable, HTMLComponent {

    public let html: HTML<Output>

    init(_ selector: String, child: DSLTree.Node) {
        self.html = .init(
            node: .local(
                selector: selector,
                child: child
            ))
    }

    public init<Component: HTMLComponent>(
        _ selector: String = "",
        @HTMLComponentBuilder _ component: () -> Component
    ) where Output == Component.HTMLOutput {
        self.html = .init(
            node: .local(
                selector: selector,
                child: component().html.node
            ))
    }

    public init<Component: HTMLComponent>(
        _ selector: String = "",
        @HTMLComponentBuilder _ component: () -> Component,
        transform: @Sendable @escaping (Component.HTMLOutput) -> Output
    ) {
        self.html = .init(
            node: .local(
                selector: selector,
                child: component().html.node,
                transform: .init(transform)
            ))
    }
}

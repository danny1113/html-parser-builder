//
//  HTML.swift
//
//
//  Created by Danny Pang on 2022/7/2.
//

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

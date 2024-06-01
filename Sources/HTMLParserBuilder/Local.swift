//
//  Local.swift
//  
//
//  Created by Danny Pang on 2022/7/9.
//

public struct Local<Output>: Sendable, HTMLComponent {
    
    public let html: HTML<Output>
    
    init(_ selector: String, child: DSLTree.Node) {
        self.html = .init(node: .local(
            selector: selector,
            child: child
        ))
    }
    
    public init<Component: HTMLComponent>(
        _ selector: String = "",
        @HTMLComponentBuilder _ component: () -> Component
    ) where Output == Component.HTMLOutput {
        self.html = .init(node: .local(
            selector: selector,
            child: component().html.node
        ))
    }
    
    public init<Component: HTMLComponent>(
        _ selector: String = "",
        @HTMLComponentBuilder _ component: () -> Component,
        transform: @escaping (Component.HTMLOutput) -> Output
    ) {
        self.html = .init(node: .local(
            selector: selector,
            child: component().html.node,
            transform: .init(transform)
        ))
    }
}

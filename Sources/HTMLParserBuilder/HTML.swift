//
//  HTML.swift
//  
//
//  Created by Danny Pang on 2022/7/2.
//

import HTMLKit


public struct HTML<Output>: HTMLComponent {
    
    let node: DSLTree.Node
    
    public var html: HTML<Output> {
        self
            .debug()
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
        transform: @escaping (Component.HTMLOutput) throws -> Output
    ) {
        let html = component().html
        self.node = .root(
            child: html.node,
            transform: CaptureTransform(transform)
        )
    }
}
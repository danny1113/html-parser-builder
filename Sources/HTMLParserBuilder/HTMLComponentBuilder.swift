//
//  HTMLComponentBuilder.swift
//
//
//  Created by Danny Pang on 2022/7/2.
//

@resultBuilder
public enum HTMLComponentBuilder {

    public static func buildBlock<each C: HTMLComponent>(
        _ component: repeat each C
    ) -> HTML<(repeat (each C).HTMLOutput)> {
        var nodes: [DSLTree.Node] = []
        repeat nodes.append((each component).html.node)

        return HTML(node: .concatenation(nodes))
    }

    public static func buildEither<Content: HTMLComponent>(
        first component: Content
    ) -> Content {
        return component
    }

    public static func buildEither<Content: HTMLComponent>(
        second component: Content
    ) -> Content {
        return component
    }

    public static func buildOptional<Content: HTMLComponent>(
        _ component: Content?
    ) -> HTML<Content> {
        if let component {
            return HTML(node: component.html.node)
        } else {
            return HTML(node: .empty)
        }
    }
}

//
//  HTMLComponentBuilder.swift
//
//
//  Created by Danny Pang on 2022/7/2.
//

@resultBuilder
@frozen
public enum HTMLComponentBuilder {
    public static func buildBlock<each C: HTMLComponent>(
        _ component: repeat each C
    ) -> HTML<(repeat (each C).Output)> {
        return HTML(component: (repeat (each component)))
    }

    public static func buildEither<each C: HTMLComponent>(
        first component: repeat each C
    ) -> (repeat each C) {
        return (repeat (each component))
    }

    public static func buildEither<each C: HTMLComponent>(
        second component: repeat each C
    ) -> (repeat each C) {
        return (repeat (each component))
    }
}

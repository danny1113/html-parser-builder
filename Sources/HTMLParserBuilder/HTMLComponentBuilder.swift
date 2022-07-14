//
//  HTMLComponentBuilder.swift
//  
//
//  Created by Danny Pang on 2022/7/2.
//


@resultBuilder
public enum HTMLComponentBuilder {
    
    public static func buildBlock<Content: HTMLComponent>(_ component: Content) -> Content {
        return component
    }
    
    public static func buildEither<Content: HTMLComponent>(first component: Content) -> Content {
        return component
    }
    
    public static func buildEither<Content: HTMLComponent>(second component: Content) -> Content {
        return component
    }
    
    public static func buildOptional<Content: HTMLComponent>(_ component: Content?) -> HTML<Content> {
        if let component {
            return HTML(node: component.html.node)
        } else {
            return HTML(node: .empty)
        }
    }
    
    public static func buildExpression<Output>(_ expression: Void) -> HTML<Output> {
        return HTML(node: .empty)
    }
    
    public static func buildExpression<Expression: HTMLComponent>(
        _ expression: Expression
    ) -> Expression {
        return expression
    }
    
    public static func buildPartialBlock<H: HTMLComponent>(
        first component: H
    ) -> HTML<H.HTMLOutput> {
        return component.html
    }
}

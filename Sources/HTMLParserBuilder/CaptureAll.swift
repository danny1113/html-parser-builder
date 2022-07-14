//
//  CaptureAll.swift
//  
//
//  Created by Danny Pang on 2022/7/9.
//

import HTMLKit


public struct CaptureAll<Output>: HTMLComponent {
    
    public let html: HTML<Output>
    
    public init(_ selector: String, transform: @escaping ([HTMLElement]) throws -> Output) {
        self.html = .init(node: .captureAll(
            selector: selector,
            transform: CaptureTransform(transform)
        ))
    }
    
    public init(_ selector: String) where Output == [HTMLElement] {
        self.html = .init(node: .captureAll(selector: selector))
    }
    
//    public init<Component>(
//        _ selector: String, @HTMLComponentBuilder component: () -> Component
//    ) where Component: HTMLComponent, Output == [Component.HTMLOutput] {
//        let child = component().html.node
//        self.html = .init(
//            node: ._captureAll(selector: selector, child: child)
//        )
//    }
//
//    public init<Component>(
//        _ selector: String, @HTMLComponentBuilder component: () -> Component,
//        transform: @escaping (Component) throws -> Output
//    ) where Component: HTMLComponent {
//        let child = component().html.node
//        self.html = .init(
//            node: ._captureAll(selector: selector, child: child)
//        )
//    }
}

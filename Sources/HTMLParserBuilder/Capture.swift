//
//  Capture.swift
//
//
//  Created by Danny Pang on 2022/7/2.
//

import HTMLKit


public struct Capture<Output>: HTMLComponent {
    
    public let html: HTML<Output>
    
    public init(_ selector: String, transform: @escaping (HTMLElement) throws -> Output) {
        self.html = .init(node: .capture(selector: selector, transform: CaptureTransform(transform)))
    }
    
//    public init(_ selector: String, @HTMLComponentBuilder component: () -> HTML<Output>) {
//        self.selector = selector
//        self.parser = component().parser
//    }
    
    public init(_ selector: String) where Output == HTMLElement {
        self.html = .init(node: .capture(selector: selector))
    }
}

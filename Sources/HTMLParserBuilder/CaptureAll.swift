//
//  CaptureAll.swift
//
//
//  Created by Danny Pang on 2022/7/9.
//


/// Capture all element that matches the CSS selector.
public struct CaptureAll<Output>: Sendable, HTMLComponent {
    
    public let html: HTML<Output>
    
    public init(_ selector: String, transform: @escaping ([any Element]) throws -> Output) {
        self.html = .init(node: .captureAll(
            selector: selector,
            transform: CaptureTransform(transform)
        ))
    }
    
    public init(_ selector: String) where Output == [any Element] {
        self.html = .init(node: .captureAll(selector: selector))
    }
}

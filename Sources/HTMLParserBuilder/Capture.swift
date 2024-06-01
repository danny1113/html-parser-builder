//
//  Capture.swift
//
//
//  Created by Danny Pang on 2022/7/2.
//

public struct Capture<Output>: Sendable, HTMLComponent {
    
    public let html: HTML<Output>
    
    public init(
        _ selector: String,
        transform: @escaping (any Element) throws -> Output
    ) {
        self.html = .init(node: .capture(
            selector: selector,
            transform: CaptureTransform(transform)
        ))
    }
    
    public init(_ selector: String) where Output == any Element {
        self.html = .init(node: .capture(selector: selector))
    }
}

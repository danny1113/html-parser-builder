//
//  TryCapture.swift
//
//
//  Created by Danny Pang on 2022/7/9.
//

public struct TryCapture<Output>: HTMLComponent {
    
    public let html: HTML<Output>
    
    public init(_ selector: String, transform: @escaping ((any Element)?) throws -> Output) {
        self.html = .init(node: .tryCapture(
            selector: selector,
            transform: CaptureTransform(transform)
        ))
    }
}

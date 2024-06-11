//
//  TryCapture.swift
//
//
//  Created by Danny Pang on 2022/7/9.
//


/// Try to capture the first element that matches the CSS selector.
///
/// This will return an optional element, if you want to throws an error when no element match the CSS selector, see ``Capture``.
///
/// To returns a first element that matches the selector #selector:
/// ```swift
/// TryCapture("#selector")
/// ```
///
/// You can also get properties from an element by provide a transform closure:
/// ```swift
/// TryCapture("#selector", transform: \.?.textContent)
/// TryCapture("#selector") { (e: (any Element)?) -> String? in
///     return e?.textContent
/// }
/// ```
public struct TryCapture<Output>: Sendable, HTMLComponent {
    
    public let html: HTML<Output>
    
    public init(_ selector: String, transform: @escaping ((any Element)?) throws -> Output) {
        self.html = .init(node: .tryCapture(
            selector: selector,
            transform: CaptureTransform(transform)
        ))
    }
}

//
//  Capture.swift
//
//
//  Created by Danny Pang on 2022/7/2.
//


/// Capture the first element that matches the CSS selector.
///
/// This will throws an error if no element match the CSS selector, if you want to returns an optional element, see ``TryCapture``.
///
/// To returns a first element that matches the selector #selector:
/// ```swift
/// Capture("#selector")
/// ```
/// 
/// You can also get properties from an element by provide a transform closure:
/// ```swift
/// Capture("#selector", transform: \.textContent)
/// Capture("#selector") { (e: (any Element)) in
///     return e.textContent
/// }
/// ```
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

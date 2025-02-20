//
//  Many.swift
//
//
//  Created by Danny Pang on 2022/7/9.
//

/// Capture all element that matches the CSS selector.
///
/// Using Many is the same as querySelectorAll,
/// you pass in CSS selector to find all HTML elements that match the selector,
/// and you can transform it to any other type you want:
///
/// ```swift
/// Many("h1") { $0.map(\.textContent) }
/// Many("h1") { (e: [any Element]) -> [String] in
///     return e.map(\.textContent)
/// }
/// ```
///
/// You can also capture other elements inside and transform to other type:
///
/// ```html
/// <div class="group">
///     <h1>Group 1</h1>
/// </div>
/// <div class="group">
///     <h1>Group 2</h1>
/// </div>
/// ```
///
/// ```swift
/// Many("div.group") { (elements: [any Element]) -> [String] in
///     return elements.compactMap { e in
///         return e.querySelector("h1")?.textContent
///     }
/// }
/// // => [String]
/// // output: ["Group 1", "Group 2"]
/// ```
@frozen
public struct Many<Output>: Sendable, HTMLComponent {

    private let selector: String
    private let transform: @Sendable ([any Element]) throws -> Output

    public init(_ selector: String) where Output == [any Element] {
        self.selector = selector
        self.transform = { e in e }
    }

    public init(
        _ selector: String,
        transform: @Sendable @escaping ([any Element]) throws -> Output
    ) {
        self.selector = selector
        self.transform = transform
    }

    public func parse(from element: any Element) throws -> Output {
        let e = element.querySelectorAll(selector)
        return try transform(e)
    }
}

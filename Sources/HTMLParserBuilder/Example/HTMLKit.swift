//
//  HTMLKit.swift
//
//
//  Created by Danny Pang on 2025/2/15.
//

// https://github.com/iabudiab/HTMLKit
private import HTMLKit
import HTMLParserBuilder

final class HTMLKitDoc: Document {
    private let document: HTMLKit.HTMLDocument

    init(string: String) {
        self.document = .init(string: string)
    }

    var rootElement: HTMLKitElement? {
        HTMLKitElement(element: document.rootElement!)
    }
}

final class HTMLKitElement: Element {
    private let element: HTMLKit.HTMLElement

    fileprivate init(element: HTMLKit.HTMLElement) {
        self.element = element
    }

    var textContent: String {
        element.textContent
    }

    var innerHTML: String {
        element.innerHTML
    }

    var outerHTML: String {
        element.outerHTML
    }

    var id: String? {
        element.elementId
    }

    var className: String {
        element.className
    }

    var classList: [String] {
        let fitted = fitted()
        let names: [String] = fitted.components(separatedBy: " ")
        return names
    }

    private func fitted() -> String {
        let className = self.className
        do {
            let regex = try NSRegularExpression(pattern: "\\s", options: [])
            let range = NSRange(0..<className.utf16.count)
            return regex.stringByReplacingMatches(
                in: className, options: [],
                range: range, withTemplate: " ")
        } catch {
            return className
        }
    }

    var attributes: [String: String] {
        element.attributes as! [String: String]
    }

    subscript(key: String) -> String? {
        element.attributes[key] as? String
    }

    func hasAttribute(_ attribute: String) -> Bool {
        element.attributes[attribute] != nil
    }

    func querySelector(_ selector: String) throws -> HTMLKitElement {
        guard let element = element.querySelector(selector) else {
            throw HTMLParseError.cantFindElement(selector: selector)
        }
        return Self(element: element)
    }

    func querySelectorAll(_ selector: String) -> [HTMLKitElement] {
        let elements = element.querySelectorAll(selector)
        return elements.map { element in
            .init(element: element)
        }
    }
}

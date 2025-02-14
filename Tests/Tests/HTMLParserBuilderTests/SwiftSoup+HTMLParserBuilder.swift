//
//  SwiftSoup+HTMLParserBuilder.swift
//
//
//  Created by Danny Pang on 2024/6/1.
//

import Foundation
import HTMLParserBuilder
import SwiftSoup

struct SoupDoc: HTMLParserBuilder.Document {
    private let doc: SwiftSoup.Document

    init(doc: SwiftSoup.Document) {
        self.doc = doc
    }

    init(string: String) throws {
        let doc = try SwiftSoup.parse(string)
        self.doc = doc
    }

    var rootElement: SoupElem {
        let elem = doc.body()!
        return SoupElem(elem: elem)
    }

    func querySelector(_ selector: String) -> SoupElem? {
        guard let elem = try? doc.select(selector).first() else {
            return nil
        }
        return SoupElem(elem: elem)
    }

    func querySelectorAll(_ selector: String) -> [SoupElem] {
        guard let elements = try? doc.select(selector) else {
            return []
        }

        return elements.map(SoupElem.init)
    }
}

struct SoupElem: HTMLParserBuilder.Element {
    private let elem: SwiftSoup.Element

    init(elem: SwiftSoup.Element) {
        self.elem = elem
    }

    func querySelector(_ selector: String) -> SoupElem? {
        guard let elem = try? elem.select(selector).first() else {
            return nil
        }
        return SoupElem(elem: elem)
    }

    func querySelectorAll(_ selector: String) -> [SoupElem] {
        guard let elements = try? elem.select(selector) else {
            return []
        }

        return elements.map(SoupElem.init)
    }

    func getElementById(_ id: String) -> SoupElem? {
        guard let element = try? elem.getElementById(id) else {
            return nil
        }
        return SoupElem(elem: element)
    }

    func getElementsByClassName(_ className: String) -> [SoupElem] {
        guard let elements = try? elem.getElementsByClass(className) else {
            return []
        }
        return elements.map(SoupElem.init)
    }

    func getElementsByTagName(_ tagName: String) -> [SoupElem] {
        guard let elements = try? elem.getElementsByTag(tagName) else {
            return []
        }
        return elements.map(SoupElem.init)
    }

    var elementId: String {
        elem.id()
    }

    var className: String {
        let className = try? elem.className()
        return className ?? ""
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
        guard let attributes = elem.getAttributes()?.asList() else {
            return [:]
        }
        var attrs = [String: String]()
        for attribute in attributes {
            attrs[attribute.getKey()] = attribute.getValue()
        }
        return attrs
    }

    func hasAttribute(_ attribute: String) -> Bool {
        elem.hasAttr(attribute)
    }

    subscript(key: String) -> String? {
        try? elem.attr(key)
    }

    var textContent: String {
        let text = try? elem.text()
        return text ?? ""
    }

    var innerHTML: String {
        let html = try? elem.html()
        return html ?? ""
    }

    var outerHTML: String {
        let html = try? elem.outerHtml()
        return html ?? ""
    }
}

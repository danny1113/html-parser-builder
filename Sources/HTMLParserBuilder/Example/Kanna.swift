//
//  Kanna.swift
//
//
//  Created by Danny Pang on 2025/2/15.
//

import HTMLParserBuilder
// https://github.com/tid-kijyun/Kanna
import Kanna

struct KannaDoc: Document {
    let doc: any Kanna.HTMLDocument

    init(string: String) throws {
        self.doc = try HTML(html: string, encoding: .utf8)
    }

    var rootElement: KannaElement? {
        guard let rootElement = doc.body else {
            return nil
        }
        return KannaElement(element: rootElement)
    }
}

struct KannaElement: Element {
    let element: any Kanna.XMLElement

    fileprivate init(element: any Kanna.XMLElement) {
        self.element = element
    }

    var textContent: String {
        element.text ?? ""
    }

    var innerHTML: String {
        element.innerHTML ?? ""
    }

    var outerHTML: String {
        element.toHTML ?? ""
    }

    var id: String? {
        nil
    }

    var className: String {
        element.className ?? ""
    }

    var classList: [String] {
        className.components(separatedBy: .whitespaces)
    }

    var attributes: [String: String] {
        // TODO
        [:]
    }

    func hasAttribute(_ attribute: String) -> Bool {
        element[attribute] != nil
    }

    subscript(key: String) -> String? {
        element[key]
    }

    func querySelector(_ selector: String) throws -> KannaElement {
        guard let element = element.at_css(selector) else {
            throw HTMLParseError.cantFindElement(selector: selector)
        }
        return KannaElement(element: element)
    }

    func querySelectorAll(_ selector: String) -> [KannaElement] {
        // TODO
        return []
    }
}

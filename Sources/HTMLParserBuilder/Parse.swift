//
//  HTMLDocument+parse.swift
//
//
//  Created by Danny Pang on 2022/7/4.
//

extension Document {
    public func parse<Output>(
        _ html: HTML<Output>
    ) throws -> Output {
        try html.parse(from: rootElement)
    }
}

extension Element {
    public func parse<Output>(
        _ html: HTML<Output>
    ) throws -> Output {
        try html.parse(from: self)
    }
}

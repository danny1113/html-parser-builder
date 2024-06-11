//
//  HTMLParseError.swift
//
//
//  Created by Danny Pang on 2024/6/2.
//

public enum HTMLParseError: Error {
    case cantFindElement(selector: String)
    case description(String)
    case other(any Error)
}

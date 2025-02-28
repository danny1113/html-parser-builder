//
//  HTMLComponent.swift
//
//
//  Created by Danny Pang on 2022/7/2.
//

/// A type that represents part of the component in html.
public protocol HTMLComponent<Output>: Sendable {

    /// A type that represents the output type of ``parse(from:)``
    associatedtype Output

    func parse(from element: any Element) throws -> Output
}

//
//  HTMLComponent.swift
//
//
//  Created by Danny Pang on 2022/7/2.
//

public protocol HTMLComponent<HTMLOutput> {
    associatedtype HTMLOutput
    var html: HTML<HTMLOutput> { get }
}

extension HTMLComponent {
    public func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
}

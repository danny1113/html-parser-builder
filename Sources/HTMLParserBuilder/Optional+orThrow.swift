//
//  Optional+orThrow.swift
//  
//
//  Created by Danny Pang on 2022/7/9.
//


extension Optional {
    public func orThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            throw errorExpression()
        }
    }
}

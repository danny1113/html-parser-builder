//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2021-2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//


struct CaptureTransform: Sendable, Hashable, CustomStringConvertible {
    
    enum Closure {
        /// A failable transform.
        case failable((Any) throws -> Any?)
        /// Specialized case of `failable` for performance.
        case HTMLElementFailable((any Element) throws -> Any?)
        /// A non-failable transform.
        case nonfailable((Any) throws -> Any)
        /// Specialized case of `failable` for performance.
        case HTMLElementNonfailable((any Element) throws -> Any?)
    }
    let argumentType: Any.Type
    let resultType: Any.Type
    let closure: Closure
    
    init(argumentType: Any.Type, resultType: Any.Type, closure: Closure) {
        self.argumentType = argumentType
        self.resultType = resultType
        self.closure = closure
    }
    
    init<Argument, Result>(
        _ userSpecifiedTransform: @escaping (Argument) throws -> Result
    ) {
        let closure: Closure
        if let HTMLElementTransform = userSpecifiedTransform
            as? (any Element) throws -> Result {
            closure = .HTMLElementNonfailable(HTMLElementTransform)
        } else {
            closure = .nonfailable {
                try userSpecifiedTransform($0 as! Argument) as Any
            }
        }
        self.init(
            argumentType: Argument.self,
            resultType: Result.self,
            closure: closure)
    }
    
    init<Argument, Result>(
        _ userSpecifiedTransform: @escaping (Argument) throws -> Result?
    ) {
        let closure: Closure
        if let HTMLElementTransform = userSpecifiedTransform
            as? (any Element) throws -> Result? {
            closure = .HTMLElementFailable(HTMLElementTransform)
        } else {
            closure = .failable {
                try userSpecifiedTransform($0 as! Argument) as Any?
            }
        }
        self.init(
            argumentType: Argument.self,
            resultType: Result.self,
            closure: closure)
    }
    
    func callAsFunction(_ _input: Any?) throws -> Any? {
        let input = _input as Any
        
        switch closure {
        case .nonfailable(let transform):
            let result = try transform(input)
            assert(type(of: result) == resultType)
            return result
        case .HTMLElementNonfailable(let transform):
            let result = try transform(input as! any Element)
//            assert(type(of: result) == resultType)
            return result
        case .failable(let transform):
            guard let result = try transform(input) else {
                return nil
            }
            assert(type(of: result) == resultType)
            return result
        case .HTMLElementFailable(let transform):
            guard let result = try transform(input as! any Element) else {
                return nil
            }
            assert(type(of: result) == resultType)
            return result
        }
    }
    
    func callAsFunction(_ input: any Element) throws -> Any? {
        switch closure {
        case .HTMLElementFailable(let transform):
            return try transform(input)
        case .HTMLElementNonfailable(let transform):
            return try transform(input)
        case .failable(let transform):
            return try transform(input)
        case .nonfailable(let transform):
            return try transform(input)
        }
    }
    
    static func == (lhs: CaptureTransform, rhs: CaptureTransform) -> Bool {
        unsafeBitCast(lhs.closure, to: (Int, Int).self) ==
        unsafeBitCast(rhs.closure, to: (Int, Int).self)
    }
    
    func hash(into hasher: inout Hasher) {
        let (fn, ctx) = unsafeBitCast(closure, to: (Int, Int).self)
        hasher.combine(fn)
        hasher.combine(ctx)
    }
    
    var description: String {
        "<transform argument_type=\(argumentType) result_type=\(resultType)>"
    }
}

//
//  LateInit.swift
//
//
//  Created by Danny Pang on 2022/7/13.
//

@propertyWrapper
@frozen
public struct LateInit<DataType> {

    public typealias InitClosure = @Sendable () -> DataType

    private var initClosure: InitClosure!
    private var _data: DataType!

    public init(
        wrappedValue: @autoclosure @escaping InitClosure
    ) {
        self.initClosure = wrappedValue
    }

    public var wrappedValue: DataType {
        mutating get {
            if initClosure != nil {
                _data = initClosure()
                initClosure = nil
            }
            return _data
        }
        set {
            _data = newValue
        }
    }
}

extension LateInit: Sendable where DataType: Sendable {}

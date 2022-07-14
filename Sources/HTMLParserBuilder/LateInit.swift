//
//  LateInit.swift
//  
//
//  Created by Danny on 2022/7/13.
//


@propertyWrapper
public struct LateInit<DataType> {
    
    typealias InitClosure = () -> DataType
    
    private var initClosure: InitClosure!
    
    public init(wrappedValue: @autoclosure @escaping () -> DataType) {
        self.initClosure = wrappedValue
    }
    
    
    private var _data: DataType!
    
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

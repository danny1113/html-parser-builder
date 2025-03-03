//
//  LateInit.swift
//
//
//  Created by Danny Pang on 2022/7/13.
//

/// Delay the initialization until the first time you access it.
///
/// Here is an example of using `LateInit`:
///
/// ```swift
/// struct Container {
///     @LateInit var parser = HTML {
///         One("h1", transform: \.textContent)
///     }
/// }
///
/// // it needs to be `var` to perform late initialization
/// var container = Container()
/// let output = doc.parse(container.parser)
/// // ...
/// ```
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

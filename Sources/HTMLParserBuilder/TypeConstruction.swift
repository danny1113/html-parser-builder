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

// Swift runtime metadata functions.
//   SWIFT_RUNTIME_EXPORT SWIFT_CC(swift)
//   MetadataResponse
//   swift_getTupleTypeMetadata(MetadataRequest request,
//                              TupleTypeFlags flags,
//                              const Metadata * const *elements,
//                              const char *labels,
//                              const ValueWitnessTable *proposedWitnesses);


@_silgen_name("swift_getTupleTypeMetadata")
private func swift_getTupleTypeMetadata(
  request: Int,
  flags: Int,
  elements: UnsafePointer<Any.Type>?,
  labels: UnsafePointer<Int8>?,
  proposedWitnesses: UnsafeRawPointer?
) -> (value: Any.Type, state: Int)

public enum TypeConstruction {
  /// Returns a tuple metatype of the given element types.
  public static func tupleType<
    ElementTypes: BidirectionalCollection
  >(
    of elementTypes: __owned ElementTypes,
    labels: String? = nil
  ) -> Any.Type where ElementTypes.Element == Any.Type {
    // From swift/ABI/Metadata.h:
    //   template <typename int_type>
    //   class TargetTupleTypeFlags {
    //     enum : int_type {
    //       NumElementsMask = 0x0000FFFFU,
    //       NonConstantLabelsMask = 0x00010000U,
    //     };
    //     int_type Data;
    //     ...
    let elementCountFlag = 0x0000FFFF
    assert(elementTypes.count != 1, "A one-element tuple is not a realistic Swift type")
    assert(elementTypes.count <= elementCountFlag, "Tuple size exceeded \(elementCountFlag)")
    
    var flags = elementTypes.count
    
    // If we have labels to provide, then say the label pointer is not constant
    // because the lifetime of said pointer will only be vaild for the lifetime
    // of the 'swift_getTupleTypeMetadata' call. If we don't have labels, then
    // our label pointer will be empty and constant.
    if labels != nil {
      // Has non constant labels
      flags |= 0x10000
    }
    
    let result = elementTypes.withContiguousStorageIfAvailable { elementTypesBuffer in
      if let labels = labels {
        return labels.withCString { labelsPtr in
          swift_getTupleTypeMetadata(
            request: 0,
            flags: flags,
            elements: elementTypesBuffer.baseAddress,
            labels: labelsPtr,
            proposedWitnesses: nil
          )
        }
      } else {
        return swift_getTupleTypeMetadata(
          request: 0,
          flags: flags,
          elements: elementTypesBuffer.baseAddress,
          labels: nil,
          proposedWitnesses: nil
        )
      }
    }
    
    guard let result = result else {
      fatalError(
        """
        The collection of element types does not support an internal representation of
        contiguous storage
        """
      )
    }
    
    return result.value
  }

  /// Creates a type-erased tuple with the given elements.
  public static func tuple<Elements: BidirectionalCollection>(
    of elements: __owned Elements
  ) -> Any where Elements.Element == Any {
    // Open existential on the overall tuple type.
    func create<T>(_: T.Type) -> Any {
      let baseAddress = UnsafeMutablePointer<T>.allocate(
        capacity: MemoryLayout<T>.size)
      defer { baseAddress.deallocate() }
      // Initialize elements based on their concrete type.
      var currentElementAddressUnaligned = UnsafeMutableRawPointer(baseAddress)
      for element in elements {
        // Open existential on each element type.
        func initializeElement<U>(_ element: U) {
          currentElementAddressUnaligned =
            currentElementAddressUnaligned.roundedUp(toAlignmentOf: U.self)
          currentElementAddressUnaligned.bindMemory(
            to: U.self, capacity: MemoryLayout<U>.size
          ).initialize(to: element)
          // Advance to the next element (unaligned).
          currentElementAddressUnaligned =
            currentElementAddressUnaligned.advanced(by: MemoryLayout<U>.size)
        }
        _openExistential(element, do: initializeElement)
      }
      return baseAddress.move()
    }
    let elementTypes = elements.map { type(of: $0) }
    return _openExistential(tupleType(of: elementTypes), do: create)
  }

  public static func arrayType(of childType: Any.Type) -> Any.Type {
    func helper<T>(_: T.Type) -> Any.Type {
      [T].self
    }
    return _openExistential(childType, do: helper)
  }

  public static func optionalType(of childType: Any.Type) -> Any.Type {
    func helper<T>(_: T.Type) -> Any.Type {
      T?.self
    }
    return _openExistential(childType, do: helper)
  }
}

extension TypeConstruction {
  public static func optionalType<Base>(
    of base: Base.Type, depth: Int = 1
  ) -> Any.Type {
    switch depth {
    case 0: return base
    case 1: return Base?.self
    case 2: return Base??.self
    case 3: return Base???.self
    case 4: return Base????.self
    default:
      return optionalType(of: Base????.self, depth: depth - 4)
    }
  }
}

extension MemoryLayout {
  /// Returns the element index that corresponnds to the given tuple element key
  /// path.
  /// - Parameters:
  ///   - keyPath: The key path from a tuple to one of its elements.
  ///   - elementTypes: The element type of the tuple type.
  // TODO: It possible to get element types from the type metadata, but it's
  // more efficient to pass them in since we already know them in the matching
  // engine.
  public static func tupleElementIndex<ElementTypes: Collection>(
    of keyPath: PartialKeyPath<T>,
    elementTypes: ElementTypes
  ) -> Int? where ElementTypes.Element == Any.Type {
    guard let byteOffset = offset(of: keyPath) else {
      return nil
    }
    if byteOffset == 0 { return 0 }
    var currentOffset = 0
    for (index, type) in elementTypes.enumerated() {
      func sizeAndAlignMask<U>(_: U.Type) -> (Int, Int) {
        (MemoryLayout<U>.size, MemoryLayout<U>.alignment - 1)
      }
      // The ABI of an offset-based key path only stores the byte offset, so
      // this doesn't work if there's a 0-sized element, e.g. `Void`,
      // `(Void, Void)`. (rdar://63819465)
      if size == 0 {
        return nil
      }
      let (size, alignMask) = _openExistential(type, do: sizeAndAlignMask)
      // Align up the offset for this type.
      currentOffset = (currentOffset + alignMask) & ~alignMask
      // If it matches the offset we are looking for, `index` is the tuple
      // element index.
      if currentOffset == byteOffset {
        return index
      }
      // Advance to the past-the-end offset for this element.
      currentOffset += size
    }
    return nil
  }
}



extension UnsafeMutableRawPointer {
  public func roundedUp<T>(toAlignmentOf type: T.Type) -> Self {
    let alignmentMask = MemoryLayout<T>.alignment - 1
    let rounded = (Int(bitPattern: self) + alignmentMask) & ~alignmentMask
    return UnsafeMutableRawPointer(bitPattern: rounded).unsafelyUnwrapped
  }
}

//
//  DSLTree.swift
//
//
//  Created by Danny Pang on 2022/7/4.
//

struct DSLTree {
    indirect enum Node: Sendable {
        case concatenation([Node])
        case capture(selector: String, transform: CaptureTransform? = nil)
        case zeroOrOne(selector: String, transform: CaptureTransform)
        case captureAll(selector: String, transform: CaptureTransform? = nil)
        case group(
            selector: String, child: Node, transform: CaptureTransform? = nil)
        case root(child: Node, transform: CaptureTransform)
        case empty
    }
}

extension DSLTree.Node: CustomStringConvertible {
    var description: String {
        switch self {
        case .concatenation(let array):
            return "concatenation \(array)"
        case .capture(let selector, _):
            return "capture (\"\(selector)\")"
        case .zeroOrOne(let selector, _):
            return "zeroOrOne (\"\(selector)\")"
        case .captureAll(let selector, _):
            return "captureAll (\"\(selector)\")"
        case .group(let selector, let node, _):
            return "group (\"\(selector)\") \(node)"
        case .root(_, _):
            return "root"
        case .empty:
            return "empty"
        }
    }
}

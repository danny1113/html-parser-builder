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
        case tryCapture(selector: String, transform: CaptureTransform)
        case captureAll(selector: String, transform: CaptureTransform? = nil)
        case local(selector: String, child: Node, transform: CaptureTransform? = nil)
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
        case .tryCapture(let selector, _):
            return "tryCapture (\"\(selector)\")"
        case .captureAll(let selector, _):
            return "captureAll (\"\(selector)\")"
        case .local(let selector, let node, _):
            return "local (\"\(selector)\") \(node)"
        case .root(_, _):
            return "root"
        case .empty:
            return "empty"
        }
    }
}

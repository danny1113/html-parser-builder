//
//  DSLTree.swift
//  
//
//  Created by Danny Pang on 2022/7/4.
//


struct DSLTree {
    indirect enum Node {
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
    func appending(_ newNode: DSLTree.Node) -> DSLTree.Node {
        if case .concatenation(let components) = self {
            return .concatenation(components + [newNode])
        }
        return .concatenation([self, newNode])
    }
    
    var description: String {
        switch self {
        case .concatenation(_):
            return "concatenation"
        case .capture(let selector, _):
            return "capture (\"\(selector)\")"
        case .tryCapture(let selector, _):
            return "tryCapture (\"\(selector)\")"
        case .captureAll(let selector, _):
            return "captureAll (\"\(selector)\")"
        case .local(let selector, _, _):
            return "local (\"\(selector)\")"
        case .root(_, _):
            return "root"
        case .empty:
            return "empty"
        }
    }
}

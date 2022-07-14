//
//  Variadics.swift
//  
//
//  Created by Danny Pang on 2022/7/9.
//


public extension HTMLComponentBuilder {
    
    // MARK: - C0
    
    static func buildPartialBlock<C0, C1, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1)> where H0.HTMLOutput == C0, H1.HTMLOutput == C1 {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2)> where H0.HTMLOutput == C0, H1.HTMLOutput == (C1, C2) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3)> where H0.HTMLOutput == C0, H1.HTMLOutput == (C1, C2, C3) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4)> where H0.HTMLOutput == C0, H1.HTMLOutput == (C1, C2, C3, C4) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5)> where H0.HTMLOutput == C0, H1.HTMLOutput == (C1, C2, C3, C4, C5) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6)> where H0.HTMLOutput == C0, H1.HTMLOutput == (C1, C2, C3, C4, C5, C6) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7)> where H0.HTMLOutput == C0, H1.HTMLOutput == (C1, C2, C3, C4, C5, C6, C7) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where H0.HTMLOutput == C0, H1.HTMLOutput == (C1, C2, C3, C4, C5, C6, C7, C8) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where H0.HTMLOutput == C0, H1.HTMLOutput == (C1, C2, C3, C4, C5, C6, C7, C8, C9) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    
    // MARK: - (C0, C1)
    
    static func buildPartialBlock<C0, C1, C2, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2)> where H0.HTMLOutput == (C0, C1), H1.HTMLOutput == C2 {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3)> where H0.HTMLOutput == (C0, C1), H1.HTMLOutput == (C2, C3) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4)> where H0.HTMLOutput == (C0, C1), H1.HTMLOutput == (C2, C3, C4) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5)> where H0.HTMLOutput == (C0, C1), H1.HTMLOutput == (C2, C3, C4, C5) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6)> where H0.HTMLOutput == (C0, C1), H1.HTMLOutput == (C2, C3, C4, C5, C6) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7)> where H0.HTMLOutput == (C0, C1), H1.HTMLOutput == (C2, C3, C4, C5, C6, C7) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where H0.HTMLOutput == (C0, C1), H1.HTMLOutput == (C2, C3, C4, C5, C6, C7, C8) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where H0.HTMLOutput == (C0, C1), H1.HTMLOutput == (C2, C3, C4, C5, C6, C7, C8, C9) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    
    // MARK: - (C0, C1, C2)
    
    static func buildPartialBlock<C0, C1, C2, C3, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3)> where H0.HTMLOutput == (C0, C1, C2), H1.HTMLOutput == C3 {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4)> where H0.HTMLOutput == (C0, C1, C2), H1.HTMLOutput == (C3, C4) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5)> where H0.HTMLOutput == (C0, C1, C2), H1.HTMLOutput == (C3, C4, C5) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6)> where H0.HTMLOutput == (C0, C1, C2), H1.HTMLOutput == (C3, C4, C5, C6) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7)> where H0.HTMLOutput == (C0, C1, C2), H1.HTMLOutput == (C3, C4, C5, C6, C7) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where H0.HTMLOutput == (C0, C1, C2), H1.HTMLOutput == (C3, C4, C5, C6, C7, C8) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where H0.HTMLOutput == (C0, C1, C2), H1.HTMLOutput == (C3, C4, C5, C6, C7, C8, C9) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    
    // MARK: - (C0, C1, C2, C3)
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4)> where H0.HTMLOutput == (C0, C1, C2, C3), H1.HTMLOutput == C4 {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5)> where H0.HTMLOutput == (C0, C1, C2, C3), H1.HTMLOutput == (C4, C5) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6)> where H0.HTMLOutput == (C0, C1, C2, C3), H1.HTMLOutput == (C4, C5, C6) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7)> where H0.HTMLOutput == (C0, C1, C2, C3), H1.HTMLOutput == (C4, C5, C6, C7) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where H0.HTMLOutput == (C0, C1, C2, C3), H1.HTMLOutput == (C4, C5, C6, C7, C8) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where H0.HTMLOutput == (C0, C1, C2, C3), H1.HTMLOutput == (C4, C5, C6, C7, C8, C9) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    
    // MARK: - (C0, C1, C2, C3, C4)
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5)> where H0.HTMLOutput == (C0, C1, C2, C3, C4), H1.HTMLOutput == C5 {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6)> where H0.HTMLOutput == (C0, C1, C2, C3, C4), H1.HTMLOutput == (C5, C6) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7)> where H0.HTMLOutput == (C0, C1, C2, C3, C4), H1.HTMLOutput == (C5, C6, C7) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where H0.HTMLOutput == (C0, C1, C2, C3, C4), H1.HTMLOutput == (C5, C6, C7, C8) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where H0.HTMLOutput == (C0, C1, C2, C3, C4), H1.HTMLOutput == (C5, C6, C7, C8, C9) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    
    // MARK: - (C0, C1, C2, C3, C4, C5)
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5), H1.HTMLOutput == C6 {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5), H1.HTMLOutput == (C6, C7) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5), H1.HTMLOutput == (C6, C7, C8) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5), H1.HTMLOutput == (C6, C7, C8, C9) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    
    // MARK: - (C0, C1, C2, C3, C4, C5, C6)
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5, C6), H1.HTMLOutput == C7 {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5, C6), H1.HTMLOutput == (C7, C8) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5, C6), H1.HTMLOutput == (C7, C8, C9) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    
    // MARK: - (C0, C1, C2, C3, C4, C5, C6, C7)
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5, C6, C7), H1.HTMLOutput == C8 {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5, C6, C7), H1.HTMLOutput == (C8, C9) {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    
    // MARK: - (C0, C1, C2, C3, C4, C5, C6, C7, C8)
    
    static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, H0: HTMLComponent, H1: HTMLComponent>(
        accumulated: H0, next: H1
    ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5, C6, C7, C8), H1.HTMLOutput == C9 {
        return HTML(node: accumulated.html.node.appending(next.html.node))
    }
    
    
    // MARK: - H0
    /*
     static func buildPartialBlock<C0, C1, H0: HTMLComponent, H1: HTMLComponent>(
     accumulated: H0, next: H1
     ) -> HTML<(C0, C1)> where H0.HTMLOutput == (C0, C1) {
     return HTML(node: accumulated.html.node.appending(next.html.node))
     }
     
     static func buildPartialBlock<C0, C1, C2, H0: HTMLComponent, H1: HTMLComponent>(
     accumulated: H0, next: H1
     ) -> HTML<(C0, C1, C2)> where H0.HTMLOutput == (C0, C1, C2) {
     return HTML(node: accumulated.html.node.appending(next.html.node))
     }
     
     static func buildPartialBlock<C0, C1, C2, C3, H0: HTMLComponent, H1: HTMLComponent>(
     accumulated: H0, next: H1
     ) -> HTML<(C0, C1, C2, C3)> where H0.HTMLOutput == (C0, C1, C2, C3) {
     return HTML(node: accumulated.html.node.appending(next.html.node))
     }
     
     static func buildPartialBlock<C0, C1, C2, C3, C4, H0: HTMLComponent, H1: HTMLComponent>(
     accumulated: H0, next: H1
     ) -> HTML<(C0, C1, C2, C3, C4)> where H0.HTMLOutput == (C0, C1, C2, C3, C4) {
     return HTML(node: accumulated.html.node.appending(next.html.node))
     }
     
     static func buildPartialBlock<C0, C1, C2, C3, C4, C5, H0: HTMLComponent, H1: HTMLComponent>(
     accumulated: H0, next: H1
     ) -> HTML<(C0, C1, C2, C3, C4, C5)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5) {
     return HTML(node: accumulated.html.node.appending(next.html.node))
     }
     
     static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, H0: HTMLComponent, H1: HTMLComponent>(
     accumulated: H0, next: H1
     ) -> HTML<(C0, C1, C2, C3, C4, C5, C6)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5, C6) {
     return HTML(node: accumulated.html.node.appending(next.html.node))
     }
     
     static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, H0: HTMLComponent, H1: HTMLComponent>(
     accumulated: H0, next: H1
     ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5, C6, C7) {
     return HTML(node: accumulated.html.node.appending(next.html.node))
     }
     
     static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, H0: HTMLComponent, H1: HTMLComponent>(
     accumulated: H0, next: H1
     ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5, C6, C7, C8) {
     return HTML(node: accumulated.html.node.appending(next.html.node))
     }
     
     static func buildPartialBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, H0: HTMLComponent, H1: HTMLComponent>(
     accumulated: H0, next: H1
     ) -> HTML<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> where H0.HTMLOutput == (C0, C1, C2, C3, C4, C5, C6, C7, C8, C9) {
     return HTML(node: accumulated.html.node.appending(next.html.node))
     }
     */
}

import XCTest
#if canImport(Combine)
import Combine
#endif
@testable import HTMLParserBuilder


final class HTMLParserBuilderTests: XCTestCase {

    private let html = #"""
    <h1>HELLO, 1</h1>
    <h1>HELLO, 2</h1>
    <h1 id="hello">HELLO, WORLD</h1>
    <div id="group">
        <h1>Inside group h1</h1>
        <h2>Inside group h2</h2>
    </div>
    <h1 class="c1">HELLO, class 1</h1>
    <h1 class="c1">HELLO, class 2</h1>
    """#

    private var doc: HTMLDocument!

    override func setUpWithError() throws {
        doc = HTMLDocument(string: html)
    }

    func testParser() throws {
        let capture = HTML {
            Capture("h1", transform: \.textContent)
            Capture("#hello", transform: \.textContent)
            Capture("h1:nth-child(2)", transform: \.textContent)
            
            Local("#group") {
                Capture("h1", transform: \.textContent)
                Capture("h2", transform: \.textContent)
            } transform: { output in
                Group(output)
            }
            
            Capture("#group", transform: Group.init)
        }

        let output = try doc.parse(capture)
        print(output)
        
        let group = Group(("Inside group h1", "Inside group h2"))
        XCTAssertEqual(output.0, "HELLO, 1")
        XCTAssertEqual(output.1, "HELLO, WORLD")
        XCTAssertEqual(output.2, "HELLO, 2")
        XCTAssertEqual(output.3, group)
        XCTAssertEqual(output.4, output.3)
    }
    
    func testDecodeFailure() throws {

        let capture = HTML {
            Capture("#hello")
            Capture("div", transform: Group.init)
            // fail
            Capture("#hello1", transform: \.textContent)
        }

        do {
            let output = try doc.parse(capture)
            print(output)
            XCTAssertTrue(false, "This test is asserted to be failed")
        } catch {
            print(error)
        }
    }
    
    func testDecodeWithTryCapture() throws {

        let capture = HTML {
            Capture("#hello")
            Capture("div", transform: Group.init)
            // returns nil
            TryCapture("#hello1", transform: \.?.textContent)
        }
        
        let output = try doc.parse(capture)
        print(output)
    }
    
    func testIfCase() throws {
        // capture has to be rebuild when flag change
        let capture = { (flag: Bool) -> HTML<String> in
            HTML {
                if flag {
                    Capture("#hello", transform: \.textContent)
                } else {
                    Capture("div", transform: \.innerHTML)
                }
            }
        }
        
        let output = try doc.parse(capture(false))
        print(output)
        
        let output2 = try doc.parse(capture(true))
        print(output2)
        
        XCTAssertNotEqual(output, output2)
    }
    
    func testLocalTransform() throws {
        let html = #"""
        <h1>HELLO, 1</h1>
        <h1>HELLO, 2</h1>
        <h1 id="hello">HELLO, WORLD</h1>
        <div id="group">
            <div class="c1">
                <h1 class="c1">HELLO, class 1</h1>
                <h2 class="c1">HELLO, class 2</h2>
            </div>
            <div class="c1">
                <h1 class="c1">HELLO, class 3</h1>
                <h2 class="c1">HELLO, class 4</h2>
            </div>
        </div>
        <h1 class="c1">HELLO, class 1</h1>
        <h1 class="c1">HELLO, class 2</h1>
        """#
        
        let capture = HTML {
            Capture("h1", transform: \.textContent)
            Capture("#hello", transform: \.textContent)
            
            Local("#group") {
                CaptureAll("div.c1") { (elements: [HTMLElement]) -> [(String, String)] in
                    let capture = HTML {
                        Capture("h1", transform: \.textContent)
                        Capture("h2", transform: \.textContent)
                    }
                    return try elements.map { try $0.parse(capture) }
                }
            } transform: { output -> [Group] in
                print("output:", output)
                return output.map(Group.init)
            }
        }
        
        let doc = HTMLDocument(string: html)
        let output = try doc.parse(capture)
        print(output)
    }
    
    func testLocalTransformAsync() async throws {
        let html = #"""
        <h1>HELLO, 1</h1>
        <h1>HELLO, 2</h1>
        <h1 id="hello">HELLO, WORLD</h1>
        <div id="group">
            <div class="c1">
                <h1 class="c1">HELLO, class 1</h1>
                <h2 class="c1">HELLO, class 2</h2>
            </div>
            <div class="c1">
                <h1 class="c1">HELLO, class 3</h1>
                <h2 class="c1">HELLO, class 4</h2>
            </div>
        </div>
        <h1 class="c1">HELLO, class 1</h1>
        <h1 class="c1">HELLO, class 2</h1>
        """#
        
        let capture = HTML {
            Capture("h1", transform: \.textContent)
            Capture("#hello", transform: \.textContent)
            
            Local("#group") {
                CaptureAll("div.c1") { (elements: [HTMLElement]) -> [(String, String)] in
                    let capture = HTML {
                        Capture("h1", transform: \.textContent)
                        Capture("h2", transform: \.textContent)
                    }
                    return try elements.map { try $0.parse(capture) }
                }
            } transform: { output -> [Group] in
                print("output:", output)
                return output.map(Group.init)
            }
        }
        
        let doc = HTMLDocument(string: html)
        let output = try await doc.parse(capture)
        print(output)
    }
    
    func testLateInit() throws {
        struct Container {
            @LateInit var string: String? = nil
            @LateInit var test: String! = "test"
        }
        
        var container = Container()
        XCTAssertNil(container.string)
        
        container.string = "hello"
        XCTAssertEqual(container.string, "hello")
        
        container.string = nil
        XCTAssertNil(container.string)
        
        
        XCTAssertEqual(container.test, "test")
        
        container.test = nil
        XCTAssertNil(container.test)
    }
    
    func testLateInitWithClass() throws {
        final class InnerContainer {
            @LateInit var string: String? = nil
            @LateInit var test: String! = "test"
        }
        
        struct Container {
            @LateInit var container = InnerContainer()
        }
        
        var container = Container()
        XCTAssertNil(container.container.string)
        XCTAssertEqual(container.container.test, "test")
        
    }
    
#if canImport(Combine)
    private var containerCancellable: AnyCancellable?
    
    func testLateInitWithPublished() throws {
        let exp = expectation(description: "wait for receive @Published message")
        
        final class Model: ObservableObject {
            @Published var container: Container!
        }
        
        struct Container {
            @LateInit var string: String? = nil
            @LateInit var test: String! = "test"
        }
        
        let model = Model()
        containerCancellable = model.$container.sink { value in
            print("container changed:", value ?? "nil")
            if value != nil {
                exp.fulfill()
            }
        }
        
        model.container = .init()
        wait(for: [exp], timeout: 1)
    }
#endif
    
}


extension HTMLParserBuilderTests {
    struct Group: Equatable, HTMLDecodable {
        let h1: String
        let h2: String
        
        init(_ output: (String, String)) {
            self.h1 = output.0
            self.h2 = output.1
        }
        
        init(from document: HTMLElement) throws {
            let capture = HTML {
                Capture("h1", transform: \.textContent)
                Capture("h2", transform: \.textContent)
            }
            let result = try document.parse(capture)
            self.h1 = result.0
            self.h2 = result.1
        }
    }
}

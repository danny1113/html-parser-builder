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

    private var doc: (any Document)!

    override func setUpWithError() throws {
        doc = try SoupDoc(string: html)
    }

    func testParser() throws {
        let capture = HTML {
            Capture("h1", transform: \.textContent)
            Capture("#hello", transform: \.textContent)
            Capture("h1:nth-child(2)", transform: \.textContent)
            
            Local("#group") {
                Capture("h1", transform: \.textContent)
                Capture("h2", transform: \.textContent)
            } transform: { output -> [Group] in
                [Group(output)]
            }
            
            Capture("#group", transform: Group.init)
        }

        let output = try doc.parse(capture)
        print(output)
        XCTAssertTrue(type(of: output) == (String, String, String, [Group], Group).self)
        
        let group = Group(("Inside group h1", "Inside group h2"))
        XCTAssertEqual(output.0, "HELLO, 1")
        XCTAssertEqual(output.1, "HELLO, WORLD")
        XCTAssertEqual(output.2, "HELLO, 2")
        XCTAssertEqual(output.3, [group])
        XCTAssertEqual(output.4, group)
    }
    
    func testEmptyCapture() throws {
        let capture = HTML {}
        
        XCTAssertTrue(type(of: capture) == HTML<Void>.self)
        XCTAssertTrue(type(of: try doc.parse(capture)) == Void.self)
    }
    
    func testSingleCapture() throws {
        let capture = HTML {
            Capture("#hello", transform: \.textContent)
        }
        
        let output = try doc.parse(capture)
        XCTAssertTrue(type(of: output) == String.self)
        XCTAssertEqual(output, "HELLO, WORLD")
    }
    
    func testDecodeFailure() throws {
        let capture = HTML {
            Capture("#hello")
            Capture("div", transform: Group.init)
            // fail
            Capture("#hello1", transform: \.textContent)
        }
        XCTAssertTrue(type(of: capture) == HTML<(any Element, Group, String)>.self)

        do {
            let _ = try doc.parse(capture)
            XCTFail("This test is asserted to be failed")
        } catch HTMLParseError.cantFindElement(let selector) {
            XCTAssertEqual(selector, "#hello1")
        } catch {
            XCTFail()
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
        XCTAssertTrue(type(of: output) == (any Element, Group, String?).self)
    }
    
    func testIfCase() throws {
        // capture has to be rebuild when flag change
        func capture(_ flag: Bool) -> HTML<String> {
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
                CaptureAll("div.c1") { (elements: [any Element]) -> [(String, String)] in
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
        
        let doc = try SoupDoc(string: html)
        let output = try doc.parse(capture)
        XCTAssertTrue(type(of: output) == (String, String, [Group]).self)
        XCTAssertEqual(output.0, "HELLO, 1")
        XCTAssertEqual(output.1, "HELLO, WORLD")
        XCTAssertEqual(output.2, [
            Group(("HELLO, class 1", "HELLO, class 2")),
            Group(("HELLO, class 3", "HELLO, class 4")),
        ])
    }
    
    func testTypeConstruction() throws {
        let capture = HTML {
            Capture("h1") { e -> (String, Int) in
                return (e.textContent, 1)
            }
            Capture("#hello") { e -> (String, i: Int) in
                return (e.textContent, 2)
            }
        }
        XCTAssertTrue(type(of: capture) == HTML<((String, Int), (String, i: Int))>.self)
        
        let output = try doc.parse(capture)
        XCTAssertTrue(type(of: output) == ((String, Int), (String, i: Int)).self)
        
        
        let capture2 = HTML {
            Capture("h1", transform: \.textContent)
            Local("#group") {
                Capture("h1", transform: \.textContent)
                Capture("h2", transform: \.textContent)
            }
        }
        
        let output2 = try doc.parse(capture2)
        XCTAssertTrue(type(of: output2) == (String, (String, String)).self)
        
        
        let capture3 = HTML {
            Local("#group") {
                Capture("h1", transform: \.textContent)
                Capture("h2", transform: \.textContent)
            }
        }
        
        let output3 = try doc.parse(capture3)
        XCTAssertTrue(type(of: output3) == (String, String).self)
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
    struct Group: Equatable {
        let h1: String
        let h2: String
        
        init(_ output: (String, String)) {
            self.h1 = output.0
            self.h2 = output.1
        }
        
        init(from document: any Element) throws {
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

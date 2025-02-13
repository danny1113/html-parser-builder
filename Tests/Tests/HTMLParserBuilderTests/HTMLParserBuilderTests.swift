import Testing
@testable import HTMLParserBuilder


struct HTMLParserBuilderTests {

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

    private var doc: any Document

    init() throws {
        doc = try SoupDoc(string: html)
    }

    @Test
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
        #expect(type(of: output) == (String, String, String, [Group], Group).self)
        
        let group = Group(("Inside group h1", "Inside group h2"))
        #expect(output.0 == "HELLO, 1")
        #expect(output.1 == "HELLO, WORLD")
        #expect(output.2 == "HELLO, 2")
        #expect(output.3 == [group])
        #expect(output.4 == group)
    }

    @Test
    func testEmptyCapture() throws {
        let capture = HTML {}
        
        #expect(type(of: capture) == HTML<Void>.self)
        #expect(type(of: try doc.parse(capture)) == Void.self)
    }

    @Test
    func testSingleCapture() throws {
        let capture = HTML {
            Capture("#hello", transform: \.textContent)
        }
        
        let output = try doc.parse(capture)
        #expect(type(of: output) == String.self)
        #expect(output == "HELLO, WORLD")
    }

    @Test
    func testDecodeFailure() throws {
        let capture = HTML {
            Capture("#hello")
            Capture("div", transform: Group.init)
            // fail
            Capture("#hello1", transform: \.textContent)
        }
        #expect(type(of: capture) == HTML<(any Element, Group, String)>.self)

        do {
            let _ = try doc.parse(capture)
            Issue.record("This test is asserted to be failed")
        } catch HTMLParseError.cantFindElement(let selector) {
            #expect(selector == "#hello1")
        } catch {
            Issue.record("Wrong error type")
        }
    }

    @Test
    func testDecodeWithTryCapture() throws {
        let capture = HTML {
            Capture("#hello")
            Capture("div", transform: Group.init)
            // returns nil
            TryCapture("#hello1", transform: \.?.textContent)
        }
        
        let output = try doc.parse(capture)
        #expect(type(of: output) == (any Element, Group, String?).self)
    }

    @Test
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
        let output2 = try doc.parse(capture(true))
        
        #expect(output != output2)
    }

    @Test
    func testTypeConstruction() throws {
        let capture = HTML {
            Capture("h1") { e -> (String, Int) in
                return (e.textContent, 1)
            }
            Capture("#hello") { e -> (String, i: Int) in
                return (e.textContent, 2)
            }
        }
        #expect(type(of: capture) == HTML<((String, Int), (String, i: Int))>.self)
        
        let output = try doc.parse(capture)
        #expect(type(of: output) == ((String, Int), (String, i: Int)).self)
        
        
        let capture2 = HTML {
            Capture("h1", transform: \.textContent)
            Local("#group") {
                Capture("h1", transform: \.textContent)
                Capture("h2", transform: \.textContent)
            }
        }
        
        let output2 = try doc.parse(capture2)
        #expect(type(of: output2) == (String, (String, String)).self)
        
        
        let capture3 = HTML {
            Local("#group") {
                Capture("h1", transform: \.textContent)
                Capture("h2", transform: \.textContent)
            }
        }
        
        let output3 = try doc.parse(capture3)
        #expect(type(of: output3) == (String, String).self)
    }

    @Test
    func testLateInit() throws {
        struct Container {
            @LateInit var string: String? = nil
            @LateInit var test: String! = "test"
        }
        
        var container = Container()
        #expect(container.string == nil)
        
        container.string = "hello"
        #expect(container.string == "hello")
        
        container.string = nil
        #expect(container.string == nil)
        
        
        #expect(container.test == "test")
        
        container.test = nil
        #expect(container.test == nil)
    }

    @Test
    func testLateInitWithClass() throws {
        final class InnerContainer {
            @LateInit var string: String? = nil
            @LateInit var test: String! = "test"
        }
        
        struct Container {
            @LateInit var container = InnerContainer()
        }
        
        var container = Container()
        #expect(container.container.string == nil)
        #expect(container.container.test == "test")
        
    }
}

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

@Test
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
            return output.map(Group.init)
        }
    }
    
    let doc = try SoupDoc(string: html)
    let output = try doc.parse(capture)
    #expect(type(of: output) == (String, String, [Group]).self)
    #expect(output.0 == "HELLO, 1")
    #expect(output.1 == "HELLO, WORLD")
    #expect(output.2 == [
        Group(("HELLO, class 1", "HELLO, class 2")),
        Group(("HELLO, class 3", "HELLO, class 4")),
    ])
}

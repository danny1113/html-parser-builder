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
            <div id="group2">
                <h1>Inside group2 h1</h1>
                <h2>Inside group2 h2</h2>
            </div>
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
        let capture: HTML<(String, String, String, [Pair], Pair)> = HTML {
            One("h1", transform: \.textContent)
            One("#hello", transform: \.textContent)
            One("h1:nth-child(2)", transform: \.textContent)

            Group("#group") {
                One("h1", transform: \.textContent)
                One("h2", transform: \.textContent)
            }
            .map { output -> [Pair] in
                [Pair(output)]
            }

            One("#group", transform: Pair.init)
        }

        let output = try doc.parse(capture)
        #expect(
            type(of: output) == (String, String, String, [Pair], Pair).self)

        let group = Pair(("Inside group h1", "Inside group h2"))
        #expect(output.0 == "HELLO, 1")
        #expect(output.1 == "HELLO, WORLD")
        #expect(output.2 == "HELLO, 2")
        #expect(output.3 == [group])
        #expect(output.4 == group)
    }

    @Test
    func testEmptyCapture() throws {
        let capture: HTML<Void> = HTML {}

        #expect(type(of: capture) == HTML<Void>.self)
        #expect(type(of: try doc.parse(capture)) == Void.self)
    }

    @Test
    func testSingleCapture() throws {
        let capture: HTML<String> = HTML {
            One("#hello", transform: \.textContent)
        }

        let output = try doc.parse(capture)
        #expect(type(of: output) == String.self)
        #expect(output == "HELLO, WORLD")
    }

    @Test
    func testDecodeFailure() throws {
        let capture: HTML<(any Element, Pair, String)> = HTML {
            One("#hello")
            One("div", transform: Pair.init)
            // fail
            One("#hello1", transform: \.textContent)
        }
        #expect(type(of: capture) == HTML<(any Element, Pair, String)>.self)

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
    func testDecodeWithZeroOrOne() throws {
        let capture: HTML<(any Element, Pair, String?)> = HTML {
            One("#hello")
            One("div", transform: Pair.init)
            // returns nil
            ZeroOrOne("#hello1", transform: \.?.textContent)
        }

        let output = try doc.parse(capture)
        #expect(type(of: output) == (any Element, Pair, String?).self)
    }

    @Test
    func testIfCase() throws {
        @HTMLComponentBuilder
        func capture(_ flag: Bool) -> HTML<String> {
            if flag {
                One("#hello", transform: \.textContent)
            } else {
                One("div", transform: \.innerHTML)
            }
        }

        let output = try doc.parse(capture(false))
        let output2 = try doc.parse(capture(true))

        #expect(output != output2)
    }

    @Test
    func testTypeConstruction() throws {
        // capture 1
        let capture1: HTML<((String, Int), (String, i: Int))> = HTML {
            One("h1") { e -> (String, Int) in
                return (e.textContent, 1)
            }
            One("#hello") { e -> (String, i: Int) in
                return (e.textContent, 2)
            }
        }

        let output1 = try doc.parse(capture1)
        #expect(type(of: output1) == ((String, Int), (String, i: Int)).self)

        // capture 2
        let capture2: HTML<(String, (String, String))> = HTML {
            One("h1", transform: \.textContent)
            Group("#group") {
                One("h1", transform: \.textContent)
                One("h2", transform: \.textContent)
            }
        }

        let output2 = try doc.parse(capture2)
        #expect(type(of: output2) == (String, (String, String)).self)

        // capture 3
        let capture3: HTML<(String, String)> = HTML {
            Group("#group") {
                One("h1", transform: \.textContent)
                One("h2", transform: \.textContent)
            }
        }

        let output3 = try doc.parse(capture3)
        #expect(type(of: output3) == (String, String).self)

        // capture 4
        let capture4: HTML<(String, String, Pair)> = HTML {
            Group("#group") {
                One("h1", transform: \.textContent)
                One("h2", transform: \.textContent)
                Group("#group2") {
                    One("h1", transform: \.textContent)
                    One("h2", transform: \.textContent)
                }
                .map(Pair.init)
            }
        }

        let output4 = try doc.parse(capture4)
        #expect(type(of: output4) == (String, String, Pair).self)
        #expect(
            output4 == (
                "Inside group h1", "Inside group h2",
                Pair(("Inside group2 h1", "Inside group2 h2"))
            ))
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

struct Pair: Equatable {
    let h1: String
    let h2: String

    init(_ output: (String, String)) {
        self.h1 = output.0
        self.h2 = output.1
    }

    init(from document: any Element) throws {
        let capture: HTML<(String, String)> = HTML {
            One("h1", transform: \.textContent)
            One("h2", transform: \.textContent)
        }
        let result = try document.parse(capture)
        self.h1 = result.0
        self.h2 = result.1
    }
}

@Test
func testGroupTransform() throws {
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
        <h1 class="c1">HELLO, class 5</h1>
        <h1 class="c1">HELLO, class 6</h1>
        """#

    let pairCapture: HTML<(String, String)> = HTML {
        One("h1", transform: \.textContent)
        One("h2", transform: \.textContent)
    }

    let groupCapture: Group<[Pair]> = Group("#group") {
        Many("div.c1") { elements -> [(String, String)] in
            return try elements.map { try $0.parse(pairCapture) }
        }
    }
    .map { (output: [(String, String)]) -> [Pair] in
        return output.map(Pair.init)
    }

    let capture: HTML<(String, String, [Pair])> = HTML {
        One("h1", transform: \.textContent)
        One("#hello", transform: \.textContent)

        groupCapture
    }

    let doc = try SoupDoc(string: html)
    let output = try doc.parse(capture)
    #expect(type(of: output) == (String, String, [Pair]).self)
    #expect(output.0 == "HELLO, 1")
    #expect(output.1 == "HELLO, WORLD")
    #expect(
        output.2 == [
            Pair(("HELLO, class 1", "HELLO, class 2")),
            Pair(("HELLO, class 3", "HELLO, class 4")),
        ])
}


# HTMLParserBuilder

A result builder that build HTML parser and transform HTML elements to strongly-typed result, inspired by RegexBuilder.

> **Note**: `CaptureTransform.swift`, `TypeConstruction.swift` are copied from [apple/swift-experimental-string-processing](https://github.com/apple/swift-experimental-string-processing/).

- [HTMLParserBuilder](#htmlparserbuilder)
  - [Installation](#installation)
    - [Requirement](#requirement)
  - [Introduction](#introduction)
  - [Usage](#api-detail-usage)
    - [Bring your own parser](#bringyourownparser)
    - [Parsing](#parsing)
    - [HTML](#html)
    - [Capture](#capture)
    - [ZeroOrOne](#zeroorone)
    - [CaptureAll](#captureall)
    - [Local](#local)
    - [LateInit](#lateinit)
    - [Wrap Up](#wrap-up)
  - [Advanced use case](#advanced-use-case)

## Installation

### Requirement

- Swift 5.9
- macOS 10.15
- iOS 13.0
- tvOS 13.0
- watchOS 6.0

```swift
dependencies: [
    // ...
    .package(name: "HTMLParserBuilder", url: "https://github.com/danny1113/html-parser-builder.git", from: "2.0.0"),
]
```

## Introduction

Parsing HTML can be complicated, for example you want to parse the simple html below:

```html
<h1 id="hello">hello, world</h1>

<div id="group">
    <h1>INSIDE GROUP h1</h1>
    <h2>INSIDE GROUP h2</h2>
</div>
```

Existing HTML parsing library have these downside:

- Name every captured element
- It can be more complex as the element you want to capture become more and more
- Error handling can be hard

```swift
let htmlString = "<html>...</html>"
let doc: any Document = HTMLDocument(string: htmlString)
let first = doc.querySelector("#hello")?.textContent

let group = doc.querySelector("#group")
let second = group?.querySelector("h1")?.textContent
let third = group?.querySelector("h2")?.textContent

if  let first = first,
    let second = second,
    let third = third {
    
    // ...
} else {
    // ...
}
```

HTMLParserBuilder comes with some really great advantages:

- Strongly-typed capture result
- Structrued syntax
- Composible API
- Error handling built in

You can construct your parser which reflect your original HTML structure:

```swift
let capture = HTML {
    ZeroOrOne("#hello") { (element: any Element?) -> String? in
        return element?.textContent
    } // => HTML<String?>
    
    Local("#group") {
        Capture("h1", transform: \.textContent) // => HTML<String>
        Capture("h2", transform: \.textContent) // => HTML<String>
    } // => HTML<(String, String)>
    
} // => HTML<(String?, (String, String))>


let htmlString = "<html>...</html>"
let doc: any Document = HTMLDocument(string: htmlString)

let output = try doc.parse(capture)
// => (String?, (String, String))
// output: (Optional("hello, world"), ("INSIDE GROUP h1", "INSIDE GROUP h2"))
```

> **Note**: You can now compose up to 10 components inside the builder, but you can group your captures inside [`Local`](#local) as a workaround.

## Usage

### Bring your own parser

HTMLParserBuilder doesn't rely on any html parser, so you can chose any html parser you want to use, as long as it conforms to the `Document` and `Element` protocol.

For example, you can use SwiftSoup as the html parser, example for conformance to the `Document` and `Element` protocol is available in `Tests/HTMLParserBuilderTests/SwiftSoup+HTMLParserBuilder.swift`.

```swift
dependencies: [
    // ...
    .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.6.0"),
    .package(name: "HTMLParserBuilder", url: "https://github.com/danny1113/html-parser-builder.git", from: "2.0.0"),
],
targets: [
    .target(name: "YourTarget", dependencies: ["SwiftSoup", "HTMLParserBuilder"]),
]
```

### Parsing

HTMLParserBuilder provides a function for parsing:

```swift
public func parse<Output>(_ html: HTML<Output>) throws -> Output
```

### HTML

You can construct your parser inside `HTML`, it can also transform to other data type.

```swift
struct Group {
    let h1: String
    let h2: String
}

let capture = HTML {
    Capture("#group h1", transform: \.textContent) // => HTML<String>
    Capture("#group h2", transform: \.textContent) // => HTML<String>
    
} transform: { (output: (String, String)) -> Group in
    return Group(
        h1: output.0,
        h2: output.1
    )
} // => HTML<Group>
```

---

### Capture

Using `Capture` is the same as `querySelector`, you pass in CSS selector to find the HTML element, and you can transform it to any other type you want:

- innerHTML
- textContent
- attributes
- ...

> **Note**: If `Capture` can't find the HTML element that match the selector, it will throw an error cause the whole parse fail, for failable capture, see [`ZeroOrOne`](#zeroorone).

You can use this API with various declaration that is most suitable for you:

```swift
Capture("#hello", transform: \.textContent)
Capture("#hello") { $0.textContent }
Capture("#hello") { (e: any Element) -> String in
    return e.textContent
}
```

### ZeroOrOne

`ZeroOrOne` is a litte different from `Capture`, it also calls `querySelector` to find the HTML element, but it returns an **optional** HTML element.

For this example, it will produce the result type of `String?`, and the result will be `nil` when the HTML element can't be found.

```swift
ZeroOrOne("#hello") { (e: (any Element)?) -> String? in
    return e?.innerHTML
}
```

### CaptureAll

Using `CaptureAll` is the same as `querySelectorAll`, you pass in CSS selector to find all HTML elements that match the selector, and you can transform it to any other type you want:

You can use this API with various declaration that is most suitable for you:

```swift
CaptureAll("h1") { $0.map(\.textContent) }
CaptureAll("h1") { (e: [any Element]) -> [String] in
    return e.map(\.textContent)
}
```

You can also capture other elements inside and transform to other type:

```html
<div class="group">
    <h1>Group 1</h1>
</div>
<div class="group">
    <h1>Group 2</h1>
</div>
```

```swift
CaptureAll("div.group") { (elements: [any Element]) -> [String] in
    return elements.compactMap { e in
        return e.querySelector("h1")?.textContent
    }
}
// => [String]
// output: ["Group 1", "Group 2"]
```

---

### Local

`Local` will find a HTML element that match the selector, and all the captures inside will find its element based on the element found by `Local`, this is useful when you just want to capture element that is inside the local group.

Just like `HTML`, `Local` can also transform captured result to other data type by adding `transform`:

```swift
struct Group {
    let h1: String
    let h2: String
}

Local("#group") {
    Capture("h1", transform: \.textContent) // => HTML<String>
    Capture("h2", transform: \.textContent) // => HTML<String>
} transform: { (output: (String, String)) -> Group in
    return Group(
        h1: output.0,
        h2: output.1
    )
} // => Group
```

> **Note**: If `Local` can't find the HTML element that match the selector, it will throw an error cause the whole parse fail, you can use [`ZeroOrOne`](#zeroorone) as alternative.

### LateInit

This library also comes with a handy property wrapper: `LateInit`, which can delay the initialization until the first time you access it.

```swift
struct Container {
    @LateInit var capture = HTML {
        Capture("h1", transform: \.textContent)
    }
}

// it needs to be `var` to perform late initialization
var container = Container()
let output = doc.parse(container.capture)
// ...
```

### Wrap Up

| API        | Use Case                                             |
| ---------- | ---------------------------------------------------- |
| Capture    | Throws error when element can't be captured          |
| ZeroOrOne  | Returns `nil` when element can't be captured         |
| CaptureAll | Capture all elements match the selector              |
| Local      | Capture elements in the local scope                  |
| LateInit   | Delay the initialization to first time you access it |

## Advanced use case

- Pass `HTMLComponent` into another
- Transform to custom data structure before parasing

```swift
struct Group {
    let h1: String
    let h2: String
}

//       |--------------------------------------------------------------|
let groupCapture = HTML {                                            // |
    Local("#group") {                                                // |
        Capture("h1", transform: \.textContent) // => HTML<String>   // |
        Capture("h2", transform: \.textContent) // => HTML<String>   // |
    } // => HTML<(String, String)>                                   // |
                                                                     // |
} transform: { output -> Group in                                    // |
    return Group(                                                    // |
        h1: output.0,                                                // |
        h2: output.1                                                 // |
    )                                                                // |
} // => HTML<Group>                                                  // |
                                                                     // |
let capture = HTML {                                                 // |
    ZeroOrOne("#hello") { (element: (any Element)?) -> String? in    // |
        return element?.textContent                                  // |
    } // => HTML<String?>                                            // |
                                                                     // |
    groupCapture // => HTML<Group> -------------------------------------|
    
} // => HTML<(String?, Group)>


let htmlString = "<html>...</html>"
let doc: any Document = HTMLDocument(string: htmlString)

let output = try doc.parse(capture)
// => (String?, Group)
```

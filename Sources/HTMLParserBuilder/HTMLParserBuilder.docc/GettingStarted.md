# Getting Started

Build your own parser.

## Overview

In this section, we'll walk through how to build your own HTML parser.

### Bring your own HTML parser

First of all, HTMLParserBuilder doesn't rely on any HTML parser,
so you can chose any html parser you want,
as long as it conforms to the ``Document`` and ``Element`` protocol.

> Examples for conformance to the ``Document`` and ``Element`` protocol
is available in `Sources/HTMLParserBuilder/Example`.

For example we use [SwiftSoup](https://github.com/scinfu/SwiftSoup) as the HTML parser:

```swift
dependencies: [
    // ...
    .package(url: "https://github.com/scinfu/SwiftSoup.git", .upToNextMajor(from: "2.8.0")),
    .package(url: "https://github.com/danny1113/html-parser-builder.git", .upToNextMajor(from: "4.0.0")),
],
targets: [
    .target(name: "YourTarget", dependencies: [
        "SwiftSoup",
        .product(name: "HTMLParserBuilder", package: "html-parser-builder"),
    ]),
]
```

### Implement the protocol requirements

There are 2 protocols that you should implement:

- ``Document`` represents the whole HTML document.
- ``Element`` represents an element inside the HTML document.

> You don't have to implement ``Document/parse(_:)`` and ``Element/parse(_:)``,
> because it's implemented in the protocol extension.

### Start building your parser

Now everything is setup, you can start building your own parser.

```swift
let parser: HTML<String> = HTML {
    One("#hello", transform: \.textContent)
}

let html = "<html>...</html>"
let doc = try SoupDoc(string: html)
let output: String = try doc.parse(parser)
```

For more information about the basic building blocks:

- ``HTML``
- ``One``
- ``ZeroOrOne``
- ``Many``
- ``Group``

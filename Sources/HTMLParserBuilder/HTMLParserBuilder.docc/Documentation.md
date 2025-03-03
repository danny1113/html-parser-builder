# ``HTMLParserBuilder``

A result builder that build HTML parser and transform HTML elements to strongly-typed result.

## Overview

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
let parser = HTML {
    ZeroOrOne("#hello") { (element: any Element?) -> String? in
        return element?.textContent
    } // => HTML<String?>
    
    Group("#group") {
        One("h1", transform: \.textContent) // => HTML<String>
        One("h2", transform: \.textContent) // => HTML<String>
    } // => HTML<(String, String)>
    
} // => HTML<(String?, (String, String))>


let htmlString = "<html>...</html>"
let doc: any Document = HTMLDocument(string: htmlString)

let output = try doc.parse(parser)
// => (String?, (String, String))
// output: (Optional("hello, world"), ("INSIDE GROUP h1", "INSIDE GROUP h2"))
```

## Topics

### Essentials

- <doc:GettingStarted>

### Basic building blocks

- ``HTML``
- ``One``
- ``ZeroOrOne``
- ``Many``
- ``Group``

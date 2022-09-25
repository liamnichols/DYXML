public protocol XML {
    func renderXML(into stream: XMLOutputStream)
}

public typealias XMLAttribute = (String, String)

/// A small wrapper around `[XMLAttribute]` to allow use of dictionary literal syntax while preserving order.
public struct XMLAttributes: ExpressibleByDictionaryLiteral {
    let elements: [XMLAttribute]

    public init(dictionaryLiteral elements: (String, String)...){
        self.elements = elements
    }
}

public protocol XML {
    var content: XML { get }
}

protocol XMLRenderable: XML {
    func renderXML(into stream: XMLOutputStream)
}

extension XML {
    var renderable: XMLRenderable {
        if let renderable = self as? XMLRenderable {
            return renderable
        } else {
            return self.content.renderable
        }
    }
}

// MARK: - Attributes

public typealias XMLAttribute = (String, String)

/// A small wrapper around `[XMLAttribute]` to allow use of dictionary literal syntax while preserving order.
public struct XMLAttributes: ExpressibleByDictionaryLiteral {
    let elements: [XMLAttribute]

    public init(dictionaryLiteral elements: (String, String)...){
        self.elements = elements
    }
}

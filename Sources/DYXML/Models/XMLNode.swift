public struct XMLNode: XMLRenderable {
    let name: String
    let attributes: [XMLAttribute]
    let children: [XML]

    public init(name: String, attributes: [XMLAttribute] = [], children: [XML] = []) {
        self.name = name
        self.attributes = attributes
        self.children = children
    }

    public func renderXML(into stream: XMLOutputStream) {
        stream.writeIndentation()
        if children.isEmpty {
            stream.writeOrphanTag(name, attributes: attributes)
            stream.writeNewLine()
        } else if let child = children.first, children.count == 1, child is String {
            stream.writeOpeningTag(name, attributes: attributes)
            child.renderable.renderXML(into: stream)
            stream.writeClosingTag(name)
            stream.writeNewLine()
        } else {
            stream.writeOpeningTag(name, attributes: attributes)
            stream.writeNewLine()
            stream.incrementIndentationLevel()
            for child in children {
                child.renderable.renderXML(into: stream)
            }
            stream.decrementIndentationLevel()
            stream.writeIndentation()
            stream.writeClosingTag(name)
            stream.writeNewLine()
        }
    }

    public var content: XML { self }
}

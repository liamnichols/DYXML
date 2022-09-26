public struct XMLSpacer: XMLRenderable {
    public init() {
    }

    public func renderXML(into stream: XMLOutputStream) {
        stream.writeNewLine()
    }

    public var content: XML { self }
}

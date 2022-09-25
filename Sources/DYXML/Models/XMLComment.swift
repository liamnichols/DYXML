public struct XMLComment: XML {
    private let value: String

    init(value: String) {
        self.value = value
    }

    public func renderXML(into stream: XMLOutputStream) {
        stream.writeIndentation()
        stream.write("<!-- \(value) -->")
        stream.writeNewLine()
    }
}

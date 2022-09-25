public struct XMLDocument: XML {
    private let version: String
    private let encoding: String
    private let children: [XML]

    init(version: String = "1.0", encoding: String = "UTF-8", children: [XML]) {
        self.version = version
        self.encoding = encoding
        self.children = children
    }

    public func renderXML(into stream: XMLOutputStream) {
        stream.write(#"<?xml version="\#(version)" encoding="\#(encoding)"?>"#)
        stream.writeNewLine()
        for child in children {
            child.renderXML(into: stream)
        }
    }
}

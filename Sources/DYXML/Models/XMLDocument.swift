public struct XMLDocument: XML {
    private let comment: String?
    private let version: String
    private let encoding: String
    private let children: [XML]

    init(comment: String? = nil, version: String = "1.0", encoding: String = "UTF-8", children: [XML]) {
        self.comment = comment
        self.version = version
        self.encoding = encoding
        self.children = children
    }

    public func renderXML(into stream: XMLOutputStream) {
        if let comment = comment {
            XMLComment(comment).renderXML(into: stream)
        }
        stream.write(#"<?xml version="\#(version)" encoding="\#(encoding)"?>"#)
        stream.writeNewLine()
        for child in children {
            child.renderXML(into: stream)
        }
    }
}

extension String: XMLRenderable {
    public func renderXML(into stream: XMLOutputStream) {
        stream.write(self)
    }

    public var content: XML { self }
}

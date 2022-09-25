import Foundation

public struct XMLComment: XML {
    private let value: String

    init(value: String) {
        self.value = value
    }

    public func renderXML(into stream: XMLOutputStream) {
        let lines = value.components(separatedBy: .newlines)

        if lines.count == 1, let value = lines.first {
            stream.writeIndentation()
            stream.write("<!-- \(value) -->")
            stream.writeNewLine()
        } else {
            stream.writeIndentation()
            stream.write("<!--")
            stream.writeNewLine()

            stream.incrementIndentationLevel()

            for line in lines {
                stream.writeIndentation()
                stream.write(line)
                stream.writeNewLine()
            }

            stream.decrementIndentationLevel()
            
            stream.writeIndentation()
            stream.write("-->")
            stream.writeNewLine()
        }
    }
}

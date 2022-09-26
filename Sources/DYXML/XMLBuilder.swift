@resultBuilder
public struct XMLBuilder {
    public typealias Expression = XML
    public typealias Component = [XML]

    public static func buildBlock(_ components: XMLBuilder.Component...) -> XMLBuilder.Component {
        return components.flatMap { $0 }
    }

    public static func buildBlock(_ component: XMLBuilder.Component) -> XMLBuilder.Component {
        return component
    }

    public static func buildExpression(_ expression: Expression) -> Component {
        return [expression]
    }

    public static func buildOptional(_ component: XMLBuilder.Component?) -> XMLBuilder.Component {
        return component ?? []
    }

    public static func buildEither(first component: XMLBuilder.Component) -> XMLBuilder.Component {
        return component
    }

    public static func buildEither(second component: XMLBuilder.Component) -> XMLBuilder.Component {
        return component
    }

    public static func buildArray(_ components: [XMLBuilder.Component]) -> XMLBuilder.Component {
        return components.flatMap { $0 }
    }
}

// MARK: - Interface

public typealias Document = XMLDocument
public extension Document {
    init(comment: String? = nil, version: String = "1.0", encoding: String = "UTF-8", @XMLBuilder children: () -> [XML]) {
        self.init(comment: comment, version: version, encoding: encoding, children: children())
    }
}

public typealias Node = XMLNode
public extension Node {
    init(_ name: String, attributes: [XMLAttribute] = [], @XMLBuilder children: () -> [XML]) {
        self.init(name: name, attributes: attributes, children: children())
    }

    init(_ name: String, attributes: XMLAttributes, @XMLBuilder children: () -> [XML]) {
        self.init(name: name, attributes: attributes.elements, children: children())
    }

    init(_ name: String, attributes: [XMLAttribute] = [], value: XML) {
        self.init(name: name, attributes: attributes, children: [value])
    }

    init(_ name: String, attributes: XMLAttributes, value: XML) {
        self.init(name: name, attributes: attributes.elements, children: [value])
    }

    func attribute(_ name: String, value: String) -> Node {
        var attributes = self.attributes
        attributes.append((name, value))

        return Node(name: self.name, attributes: attributes, children: self.children)
    }
}

public typealias Comment = XMLComment
public extension Comment {
    init(_ value: String) {
        self.init(value: value)
    }
}

public typealias Spacer = XMLSpacer

// MARK: - Legacy

public func document(@XMLBuilder children: () -> [XML]) -> XML {
    return XMLDocument(children: children())
}

public func node(_ name: String, attributes: [XMLAttribute] = [], @XMLBuilder children: () -> [XML]) -> XML {
    return XMLNode(name: name, attributes: attributes, children: children())
}

public func node(_ name: String, attributes: [XMLAttribute] = [], value: XML) -> XML {
    return XMLNode(name: name, attributes: attributes, children: [value])
}

public func comment(_ value: String) -> XML {
    return XMLComment(value: value)
}

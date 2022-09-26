import XCTest
@testable import DYXML

final class XMLTests: XCTestCase {
    func testRenderOrphanTag() {
        let brTag = XMLNode(name: "br")
        XCTAssertEqual(brTag.string, "<br/>")
    }

    func testRenderOrphanTagWithAttributes() {
        let brTag = XMLNode(
            name: "br",
            attributes: [
                ("attr1", "val1"),
                ("attr2", "val2")
            ]
        )
        XCTAssertEqual(brTag.string, "<br attr1=\"val1\" attr2=\"val2\"/>")
    }

    func testRenderTagWithOneChild() {
        let pTag = XMLNode(name: "p", children: ["Hello, World!"])
        XCTAssertEqual(pTag.string, "<p>Hello, World!</p>")
    }

    func testRenderTagWithOneChildAndAttributes() {
        let pTag = XMLNode(
            name: "p",
            attributes: [
                ("attr1", "val1"),
                ("attr2", "val2")
            ],
            children: ["Hello, World!"]
        )
        XCTAssertEqual(pTag.string, "<p attr1=\"val1\" attr2=\"val2\">Hello, World!</p>")
    }

    func testRenderTagWithMultipleChild() {
        let divTag = XMLNode(
            name: "div",
            attributes: [("key", "value")],
            children: [
                XMLNode(name: "p", children: ["Hello, World!"]),
                XMLNode(name: "p", children: ["Yolo!"]),
            ]
        )
        XCTAssertEqual(divTag.string, "<div key=\"value\"><p>Hello, World!</p><p>Yolo!</p></div>")
    }

    func testRenderXMLDocumentWithRoot() {
        let someTag = XMLNode(name: "type", children: ["9"])
        let document = XMLDocument(children: [someTag])
        XCTAssertEqual(document.string, "<?xml version=\"1.0\" encoding=\"UTF-8\"?><type>9</type>")
    }

    func testRenderXMLDocumentWithoutRoot() {
        let someTag1 = XMLNode(name: "type", children: ["9"])
        let someTag2 = XMLNode(name: "value", children: ["10"])
        let document = XMLDocument(children: [someTag1, someTag2])
        XCTAssertEqual(document.string, "<?xml version=\"1.0\" encoding=\"UTF-8\"?><type>9</type><value>10</value>")
    }

    func testRenderXMLDocumentWithoutIndentation() {
        let document = XMLDocument(children: [
            XMLNode(name: "root", children: [
                XMLNode(name: "type", children: ["9"]),
                XMLNode(name: "content", children: [
                    XMLNode(name: "text", children: ["Hello, World"])
                ])
            ])
        ])
        XCTAssertEqual(document.string, "<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><type>9</type><content><text>Hello, World</text></content></root>")
    }

    func testCustomTypes() {
        struct ResourceDocument: XML {
            let resources: [XML]

            init(@XMLBuilder resources: () -> [XML]) {
                self.resources = resources()
            }

            var content: XML {
                Document(comment: "Automatically generated, do not edit!", encoding: "utf-8") {
                    Node(name: "resources", children: resources)
                }
            }
        }

        struct ColorNode: XML {
            let name: String
            let value: String

            var content: XML {
                Node("color", value: value)
                    .attribute("name", value: name)
            }
        }

        let document = ResourceDocument {
            ColorNode(name: "primaryText", value: "@color/black")
            ColorNode(name: "primaryBackground", value: "@color/white")
        }

        XCTAssertEqual(document.toString(withIndentation: 4), """
        <!-- Automatically generated, do not edit! -->
        <?xml version="1.0" encoding="utf-8"?>
        <resources>
            <color name="primaryText">@color/black</color>
            <color name="primaryBackground">@color/white</color>
        </resources>

        """)
    }

    func testRenderXMLDocumentWithIndentation() {
        let document = XMLDocument(children: [
            XMLNode(name: "root", children: [
                XMLNode(name: "type", children: ["9"]),
                XMLNode(name: "content", children: [
                    XMLNode(name: "text", children: ["Hello, World"])
                ])
            ])
        ])
        let expectedResult = """
            <?xml version=\"1.0\" encoding=\"UTF-8\"?>
            <root>
              <type>9</type>
              <content>
                <text>Hello, World</text>
              </content>
            </root>

            """

        XCTAssertEqual(document.toString(withIndentation: 2), expectedResult)
    }

    static var allTests = [
        ("testRenderOrphanTag", testRenderOrphanTag),
        ("testRenderOrphanTagWithAttributes", testRenderOrphanTagWithAttributes),
        ("testRenderTagWithOneChild", testRenderTagWithOneChild),
        ("testRenderTagWithOneChildAndAttributes", testRenderTagWithOneChildAndAttributes),
        ("testRenderTagWithMultipleChild", testRenderTagWithMultipleChild),
        ("testRenderXMLDocumentWithRoot", testRenderXMLDocumentWithRoot),
        ("testRenderXMLDocumentWithoutRoot", testRenderXMLDocumentWithoutRoot),
        ("testRenderXMLDocumentWithoutIndentation", testRenderXMLDocumentWithoutIndentation),
        ("testRenderXMLDocumentWithIndentation", testRenderXMLDocumentWithIndentation)
    ]
}

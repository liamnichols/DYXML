import XCTest
@testable import DYXML

final class XMLBuilderTests: XCTestCase {
    func testXMLBuilderSimple() {
        let document = document {
            node("html") {
                node("p") {
                    "Test"
                }
            }
        }
        XCTAssertEqual(document.string, "<?xml version=\"1.0\" encoding=\"UTF-8\"?><html><p>Test</p></html>")
    }

    func testXMLBuilderWithChildren() {
        let document = document {
            node("html") {
                node("p", attributes: [("style", "font-weight: 'bold'")]) {
                    "Hello, "
                    node("span") {
                        "World!"
                    }
                }
                node("p") {
                    "My name is David."
                }
            }
        }
        XCTAssertEqual(document.string, "<?xml version=\"1.0\" encoding=\"UTF-8\"?><html><p style=\"font-weight: 'bold'\">Hello, <span>World!</span></p><p>My name is David.</p></html>")
    }

    func testXMLBuilderWithOptional() {
        let root = node("root") {
            if true {
                node("value", value: "true")
            }
        }
        XCTAssertEqual(root.string, "<root><value>true</value></root>")
    }

    func testXMLBuilderWithEither() {
        let root = node("root") {
            if true {
                node("value1", value: "true")
            } else {
                node("value1", value: "false")
            }

            if false {
                node("value2", value: "true")
            } else {
                node("value2", value: "false")
            }

            switch (true, false) {
            case (_, false):
                node("value3", value: "ok")
            default:
                node("value3", value: "nok")
            }
        }
        XCTAssertEqual(root.string, "<root><value1>true</value1><value2>false</value2><value3>ok</value3></root>")
    }

    func testXMLBuilderWithArray() {
        let root = node("root") {
            for i in 0...3 {
                node("value") { "\(i)" }
            }
        }
        XCTAssertEqual(root.string, "<root><value>0</value><value>1</value><value>2</value><value>3</value></root>")
    }

    func testXMLBuilderReadmeExample() {
        let xml = Document(comment: "This is a\nmultiline comment!") {
            node("gpx", attributes: [
                ("xmlns", "http://www.topografix.com/GPX/1/1"),
                ("creator", "byHand"),
                ("version", "1.1"),
                ("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance"),
                ("xsi:schemaLocation", "http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd")
            ]) {
                node("wpt", attributes: [("lat", "39.921055008"), ("lon", "3.054223107")]) {
                    node("ele", value: "12.863281")
                    node("time", value: "2005-05-16T11:49:06Z")
                    node("name", value: "Cala Sant Vicenç - Mallorca")
                    node("sym", value: "City")
                }
            }
        }

        let expectedResult = """
            <!--
              This is a
              multiline comment!
            -->
            <?xml version="1.0" encoding="UTF-8"?>
            <gpx xmlns="http://www.topografix.com/GPX/1/1" creator="byHand" version="1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
              <wpt lat="39.921055008" lon="3.054223107">
                <ele>12.863281</ele>
                <time>2005-05-16T11:49:06Z</time>
                <name>Cala Sant Vicenç - Mallorca</name>
                <sym>City</sym>
              </wpt>
            </gpx>

            """
        XCTAssertEqual(xml.toString(withIndentation: 2), expectedResult)
    }

    func testXMLBuilderComments() {
        let xml = document {
            comment("Complete list of available resources")
            node("resources") {
                comment("RGB")
                node("color", value: "red")
                node("color", value: "green")
                node("color", value: "blue")
                comment("CMYK")
                node("color", value: "cyan")
                node("color", value: "magneta")
                node("color", value: "yellow")
                node("color", value: "black")
            }
        }

        let expectedResult = """
            <?xml version="1.0" encoding="UTF-8"?>
            <!-- Complete list of available resources -->
            <resources>
              <!-- RGB -->
              <color>red</color>
              <color>green</color>
              <color>blue</color>
              <!-- CMYK -->
              <color>cyan</color>
              <color>magneta</color>
              <color>yellow</color>
              <color>black</color>
            </resources>

            """
        XCTAssertEqual(xml.toString(withIndentation: 2), expectedResult)
    }

    func testModernInterface() {
        let document = Document {
            Comment("This is an XML Document")
            Node("Root") {
                Node("Node", attributes: [
                    "foo": "bar",
                    "ordered": "true"
                ]) {
                    Node("Color", value: "red")
                    Node("Color", value: "green")
                    Node("Color", value: "blue")
                }
            }
            .attribute("root", value: "true")
        }

        XCTAssertEqual(document.toString(withIndentation: 2), """
        <?xml version="1.0" encoding="UTF-8"?>
        <!-- This is an XML Document -->
        <Root root="true">
          <Node foo="bar" ordered="true">
            <Color>red</Color>
            <Color>green</Color>
            <Color>blue</Color>
          </Node>
        </Root>

        """)
    }

    static var allTests = [
        ("testXMLBuilderSimple", testXMLBuilderSimple),
        ("testXMLBuilderWithChildren", testXMLBuilderWithChildren),
        ("testXMLBuilderWithEither", testXMLBuilderWithEither),
        ("testXMLBuilderWithArray", testXMLBuilderWithArray),
        ("testXMLBuilderComments", testXMLBuilderComments),
        ("testModernInterface", testModernInterface)
    ]
}

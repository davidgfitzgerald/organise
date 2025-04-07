import ViewInspector
import XCTest
@testable import HelloWorld

extension ContentView: Inspectable {}

final class ContentViewTests: XCTestCase {
    func testContentViewHasHelloWorld() throws {
        let view = ContentView()
        let text = try view.inspect().find(text: "Hello, World!")
        XCTAssertNotNil(text)
    }
}
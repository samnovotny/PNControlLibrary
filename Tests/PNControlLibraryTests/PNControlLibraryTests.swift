import XCTest
@testable import PNControlLibrary

final class PNControlLibraryTests: XCTestCase {
    
    let date = Date()
    func testExample() {
        
        encodeDecode()
    }

    func encodeDecode() {
        let url = Url(url: PNControlLibrary().url)
        let message = Message(expires: date, message: PNControlLibrary().text)
        let version = Version(version: "1.0.5")
        let payload: [Payload] = [.version(version), .message(message), .url(url)]
        let data = try? encodePayload(payload: payload)
        XCTAssertNotNil(data, "Encode failed.")
        decodePayload(data: data!)
    }

    func encodePayload(payload: [Payload]) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let result = try encoder.encode(payload)
        return result
    }

    func decodePayload(data: Data) {
        do {
            let contents = try JSONDecoder().decode([Payload].self, from: data)
            for cont in contents {
                switch cont {
                case .message(let msg) :
                    XCTAssertEqual(msg.expires, date)
                    XCTAssertEqual(msg.message, "Hello PNControlLibrary!")
                    XCTAssertEqual(msg.oneTime, false)
                case .url(let url) :
                    XCTAssertEqual(url.url, "https://www.apple.com")
                case .version(let version) :
                    XCTAssertEqual(version.version, "1.0.5")
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

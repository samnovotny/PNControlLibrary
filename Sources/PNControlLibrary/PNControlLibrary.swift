import Foundation

struct PNControlLibrary {
    var text = "Hello PNControlLibrary!"
}

public enum Key: CodingKey {
    case Message
    case Url
}

public enum PayloadError: Error {
    case decodeError
}

public struct Message: Codable {
    var expires: Date
    var message: String
}

public struct Url: Codable {
    var url: String
}

public enum Payload: Codable {
    case url(Url)
    case message(Message)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        if let msg = try? container.decode(Message.self, forKey: .Message) {
            self = .message(msg)
        }
        else if let url = try? container.decode(Url.self, forKey: .Url) {
            self = .url(url)
            return
        }
        else {
            throw PayloadError.decodeError
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .message(let msg):
            try container.encode(msg, forKey: .Message)
        case .url(let url):
            try container.encode(url, forKey: .Url)
        }
    }
}

public func encodePayload(payload: [Payload]) throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let result = try encoder.encode(payload)
    return result
}

public func decodePayload(data: Data) {
    do {
        let contents = try JSONDecoder().decode([Payload].self, from: data)
        for cont in contents {
            switch cont {
            case .message(let msg) :
                print("Message: \(msg.expires) - \(msg.message)")
            case .url(let url) :
                print("Url: \(url.url)")
            }
        }
    }
    catch {
        print(error.localizedDescription)
    }
}


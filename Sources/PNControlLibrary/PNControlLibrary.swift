import Foundation

struct PNControlLibrary {
    var text = "Hello PNControlLibrary!"
    var url = "https://www.apple.com"
}

public enum Key: CodingKey {
    case Message
    case Url
}

public enum PayloadError: Error {
    case decodeError
}

public struct Message: Codable {
    public var expires: Date
    public var message: String
    public var oneTime = false
    
    public init(expires: Date, message: String) {
        self.expires = expires
        self.message = message
    }
}

public struct Url: Codable {
    public var url: String
    
    public init(url: String) {
        self.url = url
    }
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


import Foundation

struct PNControlLibrary {
    var text = "Hello PNControlLibrary!"
    var url = "https://www.apple.com"
}

public enum Key: CodingKey {
    case Message
    case Url
    case Version
}

public enum PayloadError: Error {
    case decodeError
}

/// Definition of what can be in the payload: Message, URL, Version
// *** Message
public struct Message: Codable {
    public var expires: Date
    public var message: String
    public var oneTime = false
    
    public init(expires: Date, message: String) {
        self.expires = expires
        self.message = message
    }
}

// *** Url
public struct Url: Codable {
    public var url: String
    
    public init(url: String) {
        self.url = url
    }
}

// *** Version
public struct Version: Codable {
    public var version: String
    
    public init(version: String) {
        self.version = version
    }
}

// *** Payload ***
//
public enum Payload: Codable {
    case url(Url)
    case message(Message)
    case version(Version)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        if let msg = try? container.decode(Message.self, forKey: .Message) {
            self = .message(msg)
        }
        else if let url = try? container.decode(Url.self, forKey: .Url) {
            self = .url(url)
            return
        }
        else if let version = try? container.decode(Version.self, forKey: .Version) {
            self = .version(version)
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
        case .version(let version):
            try container.encode(version, forKey: .Version)
        }
    }
}


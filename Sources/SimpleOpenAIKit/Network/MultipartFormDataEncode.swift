//
//  MultipartFormDataEncoder.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/16/26.
//

import Foundation

// MARK: - Extension Data
private extension Data {
    mutating func append(_ string: String, encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

// MARK: - Dynamic Coding Key
private struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) { self.stringValue = stringValue; self.intValue = nil }
    init?(intValue: Int) { self.stringValue = "\(intValue)"; self.intValue = intValue }
}
 
// MARK: - CodingKey Path Extension
private extension Array where Element == CodingKey {
    var pathString: String {
        guard let first = self.first else { return "" }
        var result = first.stringValue
        for key in self.dropFirst() {
            if let intValue = key.intValue {
                result += "[\(intValue)]"
            } else {
                result += "[\(key.stringValue)]"
            }
        }
        return result
    }
}

private enum MultipartFormPart {
    case field(String)
    case file(FileParameters)
}
// MARK: - MultipartFormDataEncoder
public class MultipartFormDataEncodeContainer {
    private var codingPath: [CodingKey] = []
    private var parts: [String: MultipartFormPart] = [:]

    let boundary: String
    public init(boundary: String = "Boundary-\(UUID().uuidString)") {
        self.boundary = boundary
    }
    public func encodeFile(name: String, file: FileParameters) {
        self.parts[name] = .file(file)
    }
    public func encodeField(name: String, value: String) {
        self.parts[name] = .field(value)
    }
    public func encode<T: Encodable>(_ value: T) throws {
        let encoder = MultipartEncoder(codingPath: codingPath, encoder: self)
        try value.encode(to: encoder)
    }
}

#if SelectInputStream
extension MultipartFormDataEncodeContainer {
    public var serialize: InputStream {
        var inputStreams: [InputStream] = []
        
        self.parts.forEach { (field, value) in
            switch value {
            case .field(let fieldValue):
                let content = (
                    "--\(boundary)\r\n" +
                    "Content-Disposition: form-data; name=\"\(field)\"\r\n\r\n" +
                    "\(fieldValue)\r\n"
                ).data(using: .utf8)!
                inputStreams.append(InputStream(data: content))
            case .file(let file):
                let header = (
                    "--\(boundary)\r\n" +
                    "Content-Disposition: form-data; name=\"\(field)\"; filename=\"\(file.name)\"\r\n" +
                    "Content-Type: \(file.mimeType)\r\n\r\n"
                ).data(using: .utf8)!
                inputStreams.append(InputStream(data: header))
                inputStreams.append(file.raw)
                inputStreams.append(InputStream(data: "\r\n".data(using: .utf8)!))
            }
        }
        let ending = "--\(boundary)--\r\n".data(using: .utf8)!
        inputStreams.append(InputStream(data: ending))
        return ConcatenatedInputStream(streams: inputStreams)
    }
}
#else
extension MultipartFormDataEncodeContainer {
    public var serialize: InputStream {
        var body = Data()
        self.parts.forEach { (field, v) in
            body.append("--\(self.boundary)\r\n")
            switch v {
            case .field(let value):
                body.append("Content-Disposition: form-data; name=\"\(field)\"\r\n\r\n")
                body.append("\(value)\r\n")
            case .file(let file):
                body.append("Content-Disposition: form-data; name=\"\(field)\"; filename=\"\(file.name)\"\r\n")
                body.append("Content-Type: \(file.mimeType)\r\n\r\n")
                body.append(file.raw)
                body.append("\r\n")
            }
        }
        body.append("--\(self.boundary)--\r\n")
        return InputStream(data: body)
    }
}
#endif
 
// MARK: - Internal Encoder Proxy
private class MultipartEncoder: Encoder {
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey : Any] = [:]
    let encoder: MultipartFormDataEncodeContainer
    
    init(codingPath: [CodingKey], encoder: MultipartFormDataEncodeContainer) {
        self.codingPath = codingPath
        self.encoder = encoder
    }
    
    func container<Key>(keyedBy keyType: Key.Type) -> KeyedEncodingContainer<Key> {
        let container = MultipartKeyedEncodingContainer<Key>(codingPath: codingPath, encoder: encoder)
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        return MultipartUnkeyedEncodingContainer(codingPath: codingPath, encoder: encoder)
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        return MultipartSingleValueEncodingContainer(codingPath: codingPath, encoder: encoder)
    }
}
 
// MARK: - KeyedContainer
private extension MultipartEncoder {
    private struct MultipartKeyedEncodingContainer<K: CodingKey>: KeyedEncodingContainerProtocol {
        typealias Key = K
        var codingPath: [CodingKey]
        let encoder: MultipartFormDataEncodeContainer
        
        func nestedPath(forKey key: K) -> [CodingKey] { codingPath + [key] }
        func unionPath(_ name: String) -> String {
            (codingPath + [AnyCodingKey(stringValue: name)!]).pathString
        }
        
        func encodeNil(forKey key: K) throws { }
        func encode(_ value: String, forKey key: K) throws { encoder.encodeField(name: unionPath(key.stringValue), value: value) }
        func encode(_ value: Bool, forKey key: K) throws { encoder.encodeField(name: unionPath(key.stringValue), value: value.description) }
        func encode<T: Encodable>(_ value: T, forKey key: K) throws where T : Encodable {
            if let file = value as? FileParameters {
                encoder.encodeFile(name: key.stringValue, file: file)
            } else if let num = value as? any Numeric {
                encoder.encodeField(name: unionPath(key.stringValue), value: String(describing: num))
            } else {
                let nestedEncoder = MultipartEncoder(codingPath: nestedPath(forKey: key), encoder: encoder)
                try value.encode(to: nestedEncoder)
            }
        }
        func encodeIfPresent<T>(_ value: T?, forKey key: K) throws where T : Encodable {
            try encode(value, forKey: key)
        }
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            let nestedEncoder = MultipartEncoder(codingPath: nestedPath(forKey: key), encoder: encoder)
            return nestedEncoder.container(keyedBy: keyType)
        }
        
        func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
            let nestedEncoder = MultipartEncoder(codingPath: nestedPath(forKey: key), encoder: encoder)
            return nestedEncoder.unkeyedContainer()
        }
        
        //    mutating func superEncoder() -> Encoder { return MultipartEncoder(codingPath: nestedPath(forKey: AnyCodingKey(stringValue: "super") as! K), encoder: encoder) }
        func superEncoder() -> Encoder { return MultipartEncoder(codingPath: codingPath, encoder: encoder) }
        func superEncoder(forKey key: K) -> Encoder { return MultipartEncoder(codingPath: nestedPath(forKey: key), encoder: encoder) }
    }
}

// MARK: - UnkeyedContainer
private extension MultipartEncoder {
    private struct MultipartUnkeyedEncodingContainer: UnkeyedEncodingContainer {
        var codingPath: [CodingKey]
        let encoder: MultipartFormDataEncodeContainer
        var count: Int = 0
        
        mutating func nextPath() -> [CodingKey] {
            defer { count += 1 }
            return codingPath + [AnyCodingKey(intValue: count)!]
        }
        
        func encodeNil() throws { }
        mutating func encode(_ value: String) throws { encoder.encodeField(name: nextPath().pathString, value: value) }
        mutating func encode(_ value: Bool) throws { encoder.encodeField(name: nextPath().pathString, value: value.description) }
        
        mutating func encode<T: Encodable>(_ value: T) throws {
            if let file = value as? FileParameters {
                let pathName = nextPath().dropLast().pathString + "[]"
                encoder.encodeFile(name: pathName, file: file)
            } else if let num = value as? any Numeric {
                encoder.encodeField(name: nextPath().pathString, value: String(describing: num))
            } else {
                let nestedEncoder = MultipartEncoder(codingPath: nextPath(), encoder: encoder)
                try value.encode(to: nestedEncoder)
            }
        }
        
        mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            return MultipartEncoder(codingPath: nextPath(), encoder: encoder).container(keyedBy: keyType)
        }
        
        mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            return MultipartEncoder(codingPath: nextPath(), encoder: encoder).unkeyedContainer()
        }
        
        mutating func superEncoder() -> Encoder { return MultipartEncoder(codingPath: nextPath(), encoder: encoder) }
    }
}

// MARK: - SingleValueContainer
private extension MultipartEncoder {
    private struct MultipartSingleValueEncodingContainer: SingleValueEncodingContainer {
        var codingPath: [CodingKey]
        let encoder: MultipartFormDataEncodeContainer
        
        func encodeNil() throws { }
        func encode(_ value: String) throws { encoder.encodeField(name: codingPath.pathString, value: value) }
        func encode(_ value: Bool) throws { encoder.encodeField(name: codingPath.pathString, value: value.description) }
        
        func encode<T: Encodable>(_ value: T) throws {
            if let file = value as? FileParameters {
                encoder.encodeFile(name: codingPath.pathString, file: file)
            } else if let num = value as? any Numeric {
                encoder.encodeField(name: codingPath.pathString, value: String(describing: num))
            } else if let dict = value as? [String: any Codable] {
                try dict.forEach { (k, v) in
                    let nestedEncoder = MultipartEncoder(codingPath: codingPath + [AnyCodingKey(stringValue: k)!], encoder: encoder)
                    try v.encode(to: nestedEncoder)
                }
            } else {
                let nestedEncoder = MultipartEncoder(codingPath: codingPath, encoder: encoder)
                try value.encode(to: nestedEncoder)
            }
        }
    }
}

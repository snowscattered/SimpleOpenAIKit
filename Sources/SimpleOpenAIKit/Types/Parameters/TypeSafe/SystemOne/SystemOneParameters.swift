//
//  SystemOneParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

@CodableStringLiteralWithOther
public enum SystemOneImageFormat {
    case png, jpg, jpeg
    case other(String)
}

@BaseModelNoWithExtra
public struct TypeSafeImage {
    public static let type: String = "image"
    @transient public let reference: String = Self.makeReference()
    public internal(set) var part: String?
    public private(set) var format: SystemOneImageFormat?
    public private(set) var data_base64: String?
    @transient public private(set) var file: FileParameters?
    
    public init(url: URL) throws {
        self.file = try .init(url: url)
    }
    public init(file: FileParameters) {
        self.file = file
    }
    public init(base64: String, format: SystemOneImageFormat) {
        self.format = format
        self.data_base64 = base64
    }
    public static func makeReference() -> String {
        let id = UUID().uuidString
            .replacingOccurrences(of: "-", with: "")
            .lowercased()
        return "<image:\(id)>"
    }
}

@BaseModelWithExtra(encodeExtra: false)
public struct SystemOneParameters {
    public var model: String?
    public var state: SystemOneJSONConent
    public var questions: [String: SystemOneQuestion]
    public var assets: [String: TypeSafeImage]?

    public init(
        model: String? = nil,
        state: SystemOneJSONConent,
        questions: [String: SystemOneQuestion],
        assets: [String: TypeSafeImage]? = nil
    ) {
        // Read explicit assets
        let explicitAssets = assets ?? [:]
        // Map image.reference to its explicit assets key
        let aliases = explicitAssets.reduce(into: [String: String]()) {
            $0[$1.value.reference] = $1.key
        }
        // Initialize the asset collection
        var collected = explicitAssets
        // Resolve state
        let state = state.resolved(aliases, into: &collected)
        // Resolve questions
        var questions = questions
        for key in questions.keys.sorted() {
            questions[key] = questions[key]?.resolved(
                aliases,
                into: &collected
            )
        }
        // Assign multipart part names only to file-backed assets
        var partIndex = 0
        for reference in collected.keys.sorted() {
            guard collected[reference]?.file != nil else { continue }
            collected[reference]?.part = "asset-\(partIndex)"
            partIndex += 1
        }
        // Store the resolved values
        self.model = model
        self.state = state
        self.questions = questions
        self.assets = collected.isEmpty ? nil : collected
    }
    private struct SystemOneDynamicCodingKey: CodingKey {
        let stringValue: String
        var intValue: Int? { nil }
        init(_ stringValue: String) { self.stringValue = stringValue }
        init?(stringValue: String) { self.init(stringValue) }
        init?(intValue: Int) { self.init(String(intValue)) }
        static let request = Self("request")
    }
    private static let keys = Set(CodingKeys.allCases.map { $0.stringValue })
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: SystemOneDynamicCodingKey.self)
        guard let request = try container.decodeIfPresent(String.self, forKey: .request) else {
            let standard = try decoder.container(keyedBy: CodingKeys.self)
            self.init(
                model: try standard.decodeIfPresent(String.self, forKey: .model),
                state: try standard.decode(SystemOneJSONConent.self, forKey: .state),
                questions: try standard.decode([String: SystemOneQuestion].self, forKey: .questions),
                assets: try standard.decodeIfPresent([String: TypeSafeImage].self, forKey: .assets)
            )
            let c = try decoder.singleValueContainer()
            let dict = try c.decode([String: BaseType].self)
            self.extra = dict.filter { !Self.keys.contains($0.key) }
            return
        }
        let payload = try JSONDecoder().decode(Self.self, from: Data(request.utf8))
        let assets = try payload.assets?.mapValues { image -> TypeSafeImage in
            guard let part = image.part else { return image }
            let key = SystemOneDynamicCodingKey(part)
            guard container.contains(key) else {
                throw DecodingError.keyNotFound(
                    key,
                    .init(codingPath: container.codingPath, debugDescription: "SystemOne asset \(part) is missing")
                )
            }
            return TypeSafeImage(file: try container.decode(FileParameters.self, forKey: key))
        }
        self.init(
            model: payload.model,
            state: payload.state,
            questions: payload.questions,
            assets: assets.flatMap { $0.isEmpty ? nil : $0 }
        )
        self.extra = payload.extra
        try afterDecode()
    }

    public func encode(to encoder: any Encoder) throws {
        var copy = self
        try copy.beforeEncode()
        guard let encoder = encoder as? MultipartEncoder else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(model, forKey: .model)
            try container.encode(state, forKey: .state)
            try container.encode(questions, forKey: .questions)
            try container.encodeIfPresent(assets, forKey: .assets)
            var c = encoder.singleValueContainer()
            let dict = copy.extra
            try c.encode(dict)
            return
        }

        try encoder.encoder.encodeJSON(name: "request", value: self)
        for asset in (assets ?? [:]).values.sorted(by: {
            ($0.part ?? "").localizedStandardCompare($1.part ?? "") == .orderedAscending
        }) {
            guard var file = asset.file, let part = asset.part else { continue }
            file.name = part
            encoder.encoder.encodeFile(name: part, file: file)
        }
    }
}

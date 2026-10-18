//
//  SystemOneParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

@CodableLiteral
public enum SystemOneImageFormat: String {
    case png, jpg, jpeg
}

@BaseModelNoWithExtra
public struct TypeSafeImage {
    public static let type: String = "image"
    public internal(set) var part: String?
    public private(set) var format: SystemOneImageFormat?
    public private(set) var data_base64: String?
    public private(set) var reference: String = Self.makeReference()
    public private(set) var file: FileParameters?

    private enum CodingKeys: String, CodingKey {
        case type
        case format
        case data_base64
        case part
    }
    public init(url: URL) throws {
        self.file = try .init(url: url)
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

    public func encode(to encoder: any Encoder) throws {
        guard let encoder = encoder as? MultipartEncoder else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(model, forKey: .model)
            try container.encode(state, forKey: .state)
            try container.encode(questions, forKey: .questions)
            try container.encodeIfPresent(assets, forKey: .assets)
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

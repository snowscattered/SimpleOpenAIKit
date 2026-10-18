//
//  SystemOneParameters.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
public struct TypeSafeImage {
    public static let type: String = "image"
    public private(set) var reference: String = Self.makeReference()
    public internal(set) var part: String = ""
    public private(set) var file: FileParameters?

    private enum CodingKeys: String, CodingKey {
        case type
        case part
    }
    public init( file: FileParameters? = nil) {
        self.file = file
    }
    public init(url: URL) throws {
        self.init(file: try .init(url: url))
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
        // Assign multipart part names in sorted key order
        for (offset, reference) in collected.keys.sorted().enumerated() {
            collected[reference]?.part = "asset-\(offset)"
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
            $0.part.localizedStandardCompare($1.part) == .orderedAscending
        }) {
            guard var file = asset.file else { continue }
            file.name = asset.part
            encoder.encoder.encodeFile(name: asset.part, file: file)
        }
    }
}


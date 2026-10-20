//
//  TypeSafeAsyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("TypeSafeAsyncTests")
struct TypeSafeAsyncTests {
    let param: SystemOneParameters = .init(
        state: ["document": "I was charged twice. Please fix this ASAP."],
        questions: [
            "billing": .noul(instructions: "Is this ticket about billing?"),
            "tone": .choice(
                instructions: "What is the customer's tone?",
                criteria: ["calm": nil, "frustrated": nil, "angry": nil]
            ),
            "urgency": .score(
                instructions: "How urgent is this ticket?",
                criteria: ["can wait", "this week", "today"]
            ),
        ]
    )
    @Test func base64ImageUsesJSON() throws {
        let url = try #require(bundle.url(forResource: "cup1", withExtension: "jpeg"))
        let image = TypeSafeImage(
            base64: try Data(contentsOf: url).base64EncodedString(),
            format: .jpeg
        )
        let parameters = SystemOneParameters(
            state: ["photo", .image(image)],
            questions: ["damaged": .noul(instructions: "Is the cup damaged?")]
        )
        let body = try JSONEncoder().encode(parameters)
        print(String(data: body, encoding: .utf8) as Any)
    }

    @Test func fileImageUsesMultipartPart() throws {
        let url = try #require(bundle.url(forResource: "cup1", withExtension: "jpeg"))
        let data = try Data(contentsOf: url)
        let image = try TypeSafeImage(url: url)
        let parameters = SystemOneParameters(
            state: [
                "photo": .image(image),
                "encoded": "encoded-photo",
            ],
            questions: ["damaged": .noul(instructions: "Is the cup damaged?")],
            assets: [
                "encoded-photo": TypeSafeImage(
                    base64: data.base64EncodedString(),
                    format: .jpeg
                )
            ]
        )

        let encoder = MultipartFormDataEncodeContainer()
        try encoder.encode(parameters)
        let stream = encoder.serialize
        stream.with {
            print(multipartDebugText(stream.read(), boundary: encoder.boundary))
        }
    }
    @Test func asyncSystemOnePinsModel() async throws {
        let res = try await asyncTypeSafeClient.system_one(
            parameters: .init(
                model: "jev-latest",
                state: param.state,
                questions: param.questions
            )
        )
        print(res.nouls["billing"]?.noul ?? "None")
        print(res.choices["tone"]?.choice ?? "None")
        print(res.scores["urgency"]?.score ?? "None")
    }
    @Test func asyncModelsList() async throws {
        let res = try await asyncTypeSafeClient.models.list()
        for i in res.models {
            print(i.name, i.release_date, i.description)
        }
    }
    @Test func asyncSystemOneWithImages() async throws {
        let cup1URL = try #require(bundle.url(forResource: "cup1", withExtension: "jpeg"))
        let cup2URL = try #require(bundle.url(forResource: "cup2", withExtension: "jpeg"))
        async let cup1 = damageProbability(forImageAt: cup1URL)
        async let cup2 = damageProbability(forImageAt: cup2URL)
        let (cup1Damage, cup2Damage) = try await (cup1, cup2)
        print("cup1 damaged probability: \(cup1Damage)")
        print("cup2 damaged probability: \(cup2Damage)")
    }
    private struct ImageDamageAnswers: Decodable, Sendable {
        let damaged: SystemOneAnswerNoul
    }
    private struct ImageDamageResponse: Decodable, Sendable {
        let answers: ImageDamageAnswers
    }
    private func damageProbability(forImageAt url: URL) async throws -> Double {
        let image = try TypeSafeImage(url: url)
        let parameters = SystemOneParameters(
            model: "jev-1.14.0",
            state: [
                "Inspect the cup shown in this image.",
                .image(image),
            ],
            questions: [
                "damaged": .noul(
                    instructions: "Is the cup broken or damaged?"
                )
            ]
        )

        let response = try await asyncTypeSafeClient.system_one(
            parameters: parameters,
            response_model: ImageDamageResponse.self,
            requestOptions: .init(extra_headers: ["TypeSafe-Danger-Zone-Images": "true"])
        )
        return response.answers.damaged.noul
    }
}

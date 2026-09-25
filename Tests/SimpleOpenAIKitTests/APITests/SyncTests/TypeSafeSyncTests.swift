//
//  TypeSafeSyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

import Testing
import Foundation
@testable import SimpleOpenAIKit

@Suite("TypeSafeSyncTests")
struct TypeSafeSyncTests {
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
    @Test func syncSystemOneEvaluate() throws {
        let res = try typeSafeClient.system_one(parameters: param)
        print(res.nouls["billing"]?.noul ?? "None")
        print(res.choices["tone"]?.choice ?? "None")
        print(res.scores["urgency"]?.score ?? "None")
    }
    @Test func syncSystemOnePinsModel() throws {
        let res = try typeSafeClient.system_one(
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
    @Test func syncModelsList() throws {
        let res = try typeSafeClient.models.list()
        for i in res.models {
            print(i.name, i.release_date, i.description)
        }
    }
}

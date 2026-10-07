//
//  DecisionAsyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import Testing
import SimpleOpenAIKit

@Suite("DecisionAsyncTests")
struct DecisionAsyncTests {
    let parameters: DecisionCreateParameters = .init(
        input: "I was charged twice. Please fix this ASAP.",
        model: "gpt-6-luna",
        questions: [
            .predicate(
                name: "billing",
                instructions: "Is this ticket about billing?"
            ),
            .choice(
                name: "tone",
                instructions: "What is the customer's tone?",
                choices: ["calm", "frustrated", "angry"]
            ),
            .score(
                name: "urgency",
                instructions: "How urgent is this ticket?",
                levels: ["can wait", "this week", "today"]
            ),
        ]
    )

    @Test func asyncDecisionCreate() async throws {
        let result = try await asyncClient.decisions.create(
            parameters: parameters
        )
        #expect(result.answers.count == parameters.questions.count)
        for item in result.answers {
            switch item {
            case .predicate(let p): print(p.name as Any, p.probability)
            case .choice(let choice):
                print(choice.name as Any, choice.choice)
                print(choice.probabilities)
            case .score(let score):
                print(score.name as Any, score.score)
                print(score.probabilities)
            case .refusal: print("refusal")
            }
        }
    }
}

//
//  DecisionSyncTests.swift
//  SimpleOpenAIKit
//
//  Created by snowscattered on 2026/10/7.
//

import Foundation
import Testing
@testable import SimpleOpenAIKit

@Suite("DecisionSyncTests")
struct DecisionSyncTests {
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

    @Test func syncDecisionCreate() throws {
        let result = try client.decisions.create(
            parameters: parameters
        )

        #expect(result.answers.count == parameters.questions.count)
        for (question, answer) in zip(parameters.questions, result.answers) {
            switch (question, answer) {
            case (.predicate, .predicate(let p)): print(p.probability)
            case (.choice, .choice(let choice)):
                print(choice.name as Any, choice.choice.value)
                print(choice.probabilities)
            case (.score, .score(let score)):
                print(score.name as Any, score.score)
                print(score.probabilities)
            default: print("refusal: \(question.type) vs \(answer.type)")
            }
        }
    }
}

//
//  ResponseTool.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelWithExtra
public struct ResponseBaseTool {
    public var type: String
}

@CodableByConstant(defaultCase: "other")
public enum ResponseTool {
    case function(ResponseFunctionTool)
    case custom(ResponseCustomTool)
    case namespace(ResponseNamespaceTool)
    case file_search(ResponseFileSearchTool)
    case image_generation(ResponseImageGenerationTool)
    case web_search(ResponseWebSearchTool)
    // Extension OpenAI
    case other(ResponseBaseTool)
}

// Add Simple Use
extension ResponseTool {
    public static var image_generation: ResponseTool {
        return .image_generation(.init())
    }
    public static var web_search: ResponseTool {
        return .web_search(.init())
    }
}
extension ResponseTool: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = BaseType
    public init(dictionaryLiteral elements: (String, Value)...) {
        let dict = Dictionary(uniqueKeysWithValues: elements)
        guard let data = try? JSONEncoder().encode(dict),
              let tool = try? JSONDecoder().decode(ResponseTool.self, from: data)
        else {
            let typeValue = (elements.first(where: { $0.0 == "type" })?.1 as? String) ?? "other"
            var extraDict = Dictionary(uniqueKeysWithValues: elements)
            extraDict.removeValue(forKey: "type")
            let baseTool = ResponseBaseTool(type: typeValue, extra: extraDict)
            self = .other(baseTool)
            return
        }
        self = tool
    }
}


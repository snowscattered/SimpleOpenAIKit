import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct CodableByConstantMacro: ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw MacroError("@CodableByStaticType can only be applied to enums")
        }

        let enumName = enumDecl.name.text
        let access = declAccessModifier(of: enumDecl)
        
        // Parse parameters
        var field = "type"
        var defaultCaseName: String? = nil
        var nilCaseName: String? = nil
        var nilCaseStill = false
        if case let .argumentList(args) = node.arguments {
            if let fieldArg = args.first(where: { $0.label?.text == "field" }),
               let stringLit = fieldArg.expression.as(StringLiteralExprSyntax.self),
               let segment = stringLit.segments.first?.as(StringSegmentSyntax.self) {
                field = segment.content.text
            }
            if let nilArg = args.first(where: { $0.label?.text == "nilCase" }),
               let stringLit = nilArg.expression.as(StringLiteralExprSyntax.self),
               let segment = stringLit.segments.first?.as(StringSegmentSyntax.self) {
                nilCaseName = segment.content.text
            }
            if let stillArg = args.first(where: { $0.label?.text == "still" }),
               let boolLit = stillArg.expression.as(BooleanLiteralExprSyntax.self) {
                nilCaseStill = boolLit.literal.tokenKind == .keyword(.true)
            }
            if let defaultArg = args.first(where: { $0.label?.text == "defaultCase" }),
               let stringLit = defaultArg.expression.as(StringLiteralExprSyntax.self),
               let segment = stringLit.segments.first?.as(StringSegmentSyntax.self) {
                defaultCaseName = segment.content.text
            }
//            if let singleArg = args.first(where: { $0.label?.text == "singleCase" }),
//               let stringLit = singleArg.expression.as(StringLiteralExprSyntax.self),
//               let segment = stringLit.segments.first?.as(StringSegmentSyntax.self) {
//                singleCaseName = segment.content.text
//            }
        }

        let enumCaseDecls = enumDecl.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }

        var regularCases: [(caseName: String, typeName: String, constantValues: [String]?)] = []
        var nilCase: (caseName: String, typeName: String)? = nil
        var fallbackCase: (caseName: String, typeName: String)? = nil

        for caseDecl in enumCaseDecls {
            let constantValues = try multiConstantValues(from: caseDecl)

            for ec in caseDecl.elements {
                let caseName = ec.name.text
                guard let params = ec.parameterClause?.parameters,
                      params.count == 1,
                      let param = params.first
                else {
                    throw MacroError("@CodableByStaticType cases must have exactly one associated value")
                }
                let entry: (caseName: String, typeName: String) = (caseName, param.type.trimmedDescription)

                if caseName == defaultCaseName { fallbackCase = entry }
                if caseName == nilCaseName {
                    nilCase = entry
                    if nilCaseStill {
                        regularCases.append((entry.caseName, entry.typeName, constantValues))
                    }
                } else if caseName != defaultCaseName {
                    regularCases.append((entry.caseName, entry.typeName, constantValues))
                }
            }
        }

        guard !regularCases.isEmpty else {
            throw MacroError("@CodableByStaticType requires at least one case")
        }
        // MARK: - Decode
        let decodeCases = regularCases.map { Case in
            let pattern = Case.constantValues?.joined(separator: ", ") ?? "\(Case.typeName).\(field)"
            return "case \(pattern): self = .\(Case.caseName)(try c.decode(\(Case.typeName).self))"
        }.joined(separator: "\n")

        let nilBranch: String
        if let nilC = nilCase {
            nilBranch = "case nil: self = .\(nilC.caseName)(try c.decode(\(nilC.typeName).self))"
        } else {
            nilBranch = ""
        }
        
        let defaultBranch: String
        if let fallback = fallbackCase {
            defaultBranch = "default: self = .\(fallback.caseName)(try c.decode(\(fallback.typeName).self))"
        } else {
            defaultBranch = "default: throw DecodingError.dataCorruptedError(forKey: .\(field), in: container, debugDescription: \"Unknown \(field): \\(field ?? \"null\")\")"
        }
        // MARK: - Encode
        var allCases: [(caseName: String, typeName: String)] = regularCases.map { ($0.caseName, $0.typeName) }
        if let nilC = nilCase,
           !nilCaseStill {
            allCases.append(nilC)
        }
        if let fallback = fallbackCase, nilCaseName != defaultCaseName { allCases.append(fallback) }
        
        let encodeCases = allCases.map { Case in
            "case .\(Case.caseName)(let v): try c.encode(v)"
        }.joined(separator: "\n")

        let ext: DeclSyntax = """
            nonisolated extension \(raw: enumName): BaseModel {
                private enum CodingKeys: String, CodingKey { case \(raw: field) }
                \(raw: access)init(from decoder: Decoder) throws {
                    
            
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let field = try container.decodeIfPresent(String.self, forKey: .\(raw: field))
                    let c = try decoder.singleValueContainer()
                    switch field {
                    \(raw: nilBranch)
                    \(raw: decodeCases)
                    \(raw: defaultBranch)
                    }
                }

                \(raw: access)func encode(to encoder: Encoder) throws {
                    var c = encoder.singleValueContainer()
                    switch self {
                    \(raw: encodeCases)
                    }
                }
            }
            """

        guard let extensionDecl = ext.as(ExtensionDeclSyntax.self) else {
            return []
        }
        return [extensionDecl]
    }
}

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implements `@SingleOrArray`: decodes a field the API sends either as one value or as an array.
struct SingleOrArrayMacro: ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw MacroError("@SingleOrArray can only be applied to enums")
        }

        let enumName = enumDecl.name.text
        let access = declAccessModifier(of: enumDecl)

        // Collect cases with associated values
        let enumCases = enumDecl.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap { $0.elements }

        guard enumCases.count == 2 else {
            throw MacroError("@SingleOrArray requires exactly two cases")
        }

        // Identify single-value case vs array case
        var singleCase: (name: String, typeName: String)?
        var arrayCase: (name: String, elementType: String)?

        for ec in enumCases {
            let caseName = ec.name.text
            guard let params = ec.parameterClause?.parameters,
                  params.count == 1,
                  let param = params.first
            else {
                throw MacroError("@SingleOrArray cases must have exactly one associated value")
            }

            if let arrType = param.type.as(ArrayTypeSyntax.self) {
                arrayCase = (caseName, arrType.element.trimmedDescription)
            } else {
                singleCase = (caseName, param.type.trimmedDescription)
            }
        }

        guard let single = singleCase, let array = arrayCase else {
            throw MacroError("@SingleOrArray requires one case with a single value and one with an array of the same element type")
        }

        let members = memberNames(of: enumDecl)

        let inheritedTypes = Set(
            enumDecl.inheritanceClause?.inheritedTypes.map {
                $0.type.trimmedDescription.split(separator: ".").last.map(String.init) ?? ""
            } ?? []
        )
        var literalProtocols: [String] = []
        var literalInitializers: [String] = []

        if let literal = literalConformance(for: single.typeName),
           !inheritedTypes.contains(literal.protocolName),
           !members.contains("init(\(literal.initializerLabel):)") {
            literalProtocols.append(literal.protocolName)
            literalInitializers.append(
                "\(access)init(\(literal.initializerLabel) value: \(literal.valueType)) { self = .\(single.name)(value) }"
            )
        }

        if !inheritedTypes.contains("ExpressibleByArrayLiteral"),
           !members.contains("init(arrayLiteral:)") {
            literalProtocols.append("ExpressibleByArrayLiteral")
            literalInitializers.append(
                "\(access)init(arrayLiteral elements: \(array.elementType)...) { self = .\(array.name)(elements) }"
            )
        }

        let decodeDecl = members.contains("init(from:)") ? "// Customized By you" : """
            \(access)init(from decoder: any Decoder) throws {
                let container = try decoder.singleValueContainer()
                if (try? container.decode(\(single.typeName).self)) == nil &&
                    (try? container.decode([BaseType].self)) == nil {
                    throw DecodingError.typeMismatch(
                        \(single.typeName).self, .init(
                        codingPath: container.codingPath,
                        debugDescription: "Expected \(single.typeName) or Array[\(array.elementType)]"
                    ))
                }

                if let s = try? container.decode(\(single.typeName).self) {
                    self = .\(single.name)(s)
                    return
                }
                let array = try container.decode([\(array.elementType)].self)
                self = .\(array.name)(array)
            }
            """
        let encodeDecl = members.contains("encode(to:)") ? "// Customized By you" : """
            \(access)func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .\(single.name)(let v): try container.encode(v)
                case .\(array.name)(let v):  try container.encode(v)
                }
            }
            """
        let ext: DeclSyntax = """
            nonisolated extension \(raw: enumName): BaseModel {
            \(raw: decodeDecl)
            \(raw: encodeDecl)
            }
            """

        var extensions: [ExtensionDeclSyntax] = []
        if let extensionDecl = ext.as(ExtensionDeclSyntax.self) {
            extensions.append(extensionDecl)
        }

        if !literalProtocols.isEmpty {
            let literalExt: DeclSyntax = """
                nonisolated extension \(raw: enumName): \(raw: literalProtocols.joined(separator: ", ")) {
                \(raw: literalInitializers.joined(separator: "\n"))
                }
                """
            if let literalExtensionDecl = literalExt.as(ExtensionDeclSyntax.self) {
                extensions.append(literalExtensionDecl)
            }
        }

        return extensions
    }
}

private struct LiteralConformance {
    let protocolName: String
    let initializerLabel: String
    let valueType: String
}

/// Types whose single payload can be built directly from a standard library literal.
private func literalConformance(for typeName: String) -> LiteralConformance? {
    switch typeName.split(separator: ".").last.map(String.init) ?? typeName {
    case "String":
        return LiteralConformance(
            protocolName: "ExpressibleByStringLiteral",
            initializerLabel: "stringLiteral",
            valueType: "String"
        )
    case "Int":
        return LiteralConformance(
            protocolName: "ExpressibleByIntegerLiteral",
            initializerLabel: "integerLiteral",
            valueType: "Int"
        )
    case "Double":
        return LiteralConformance(
            protocolName: "ExpressibleByFloatLiteral",
            initializerLabel: "floatLiteral",
            valueType: "Double"
        )
    case "Bool":
        return LiteralConformance(
            protocolName: "ExpressibleByBooleanLiteral",
            initializerLabel: "booleanLiteral",
            valueType: "Bool"
        )
    default: return nil
    }
}

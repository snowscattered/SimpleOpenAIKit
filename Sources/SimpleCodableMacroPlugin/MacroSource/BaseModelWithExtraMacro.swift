import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct BaseModelWithExtraMacro: MemberMacro, ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MacroError("@BaseModelWithExtra can only be applied to structs")
        }

        let access = declAccessModifier(of: structDecl)
        let extraProperty: DeclSyntax = "\(raw: access)var extra: [String : BaseType] = [:]"
        return [extraProperty]
    }
    
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MacroError("@BaseModelWithExtra can only be applied to structs")
        }

        let typeName = structDecl.name.text
        let stored = collectStoredProperties(of: structDecl)
        let access = declAccessModifier(of: structDecl)

        let codingKeysCases = stored.map { "case \($0.name)" }.joined(separator: "\n")
        let members = memberNames(of: structDecl)
        let customKeys = memberNames(of: structDecl, in: "CodingKeys")  // Undefined is empty
        let coding = customKeys.isEmpty ? stored : stored.filter { customKeys.contains(unquote(fromCaseName: $0.name)) }
        let codingKeysLiterals = coding.map { "\"\(unquote(fromCaseName: $0.name))\"" }.joined(separator: ", ")
        // MARK: - CodingKey
        let codingKeysDecl = !customKeys.isEmpty || stored.isEmpty ? "// Customized By you" : """
            enum CodingKeys: String, CodingKey, CaseIterable {
            \(codingKeysCases)
            }
            """
        // MARK: - Decode
        let decodable = coding.filter { !$0.isStatic && !$0.isImmutableWithDefault }
        let decodeBody = decodable.map { prop -> String in
            // `var` with a default value: `decodeIfPresent` alone would turn a missing key
            // into nil, and `decode` would throw, so keep the default when the key is absent.
            if prop.isMutable, let defaultValue = prop.defaultValue {
                let method = prop.isOptional ? "decodeIfPresent" : "decode"
                return """
                if container.contains(.\(prop.name)) {
                    self.\(prop.name) = try container.\(method)(\(prop.typeName).self, forKey: .\(prop.name))
                } else {
                    self.\(prop.name) = \(defaultValue)
                }
                """
            }
            if prop.isOptional {
                return "self.\(prop.name) = try container.decodeIfPresent(\(prop.typeName).self, forKey: .\(prop.name))"
            } else {
                return "self.\(prop.name) = try container.decode(\(prop.typeName).self, forKey: .\(prop.name))"
            }
        }.joined(separator: "\n")
        let decodeContainer = decodeBody.isEmpty ? "// No Decodable properties" : """
        let container = try decoder.container(keyedBy: CodingKeys.self)
        \(decodeBody)
        """
        let decodeFilterPart = stored.isEmpty ? "self.extra = dict" : """
            let keys: Set<String> = [\(codingKeysLiterals)]
            self.extra = dict.filter { !keys.contains($0.key) }
            """
        let decodeDecl = members.contains("init(from:)") ? "// Customized By you" : """
            \(access)init(from decoder: any Decoder) throws {
                \(decodeContainer)

                let c = try decoder.singleValueContainer()
                let dict = try c.decode([String: BaseType].self)
                \(decodeFilterPart)

                try self.after()
            }
            """
        // MARK: - Encode
        let encodable = coding.filter { !$0.isTransient }
        let encodeBody = encodable.map { prop in
            let accessor = prop.isStatic ? "Self" : "self"
            if prop.isOptional {
                return "try container.encodeIfPresent(\(accessor).\(prop.name), forKey: .\(prop.name))"
            } else {
                return "try container.encode(\(accessor).\(prop.name), forKey: .\(prop.name))"
            }
        }.joined(separator: "\n")
        let encodeContainer = encodeBody.isEmpty ? "// No Encodable properties" : """
        var container = encoder.container(keyedBy: CodingKeys.self)
        \(encodeBody)
        """
        let encodeDecl = members.contains("encode(to:)") ? "// Customized By you" : """
            \(access)func encode(to encoder: any Encoder) throws {
                \(encodeContainer)

                var c = encoder.singleValueContainer()
                let dict = extra
                try c.encode(dict)
            }
            """
        // MARK: - EXT
        let ext: DeclSyntax = """
            nonisolated extension \(raw: typeName): BaseModelWithExtra {
                \(raw: codingKeysDecl)

                \(raw: decodeDecl)

                \(raw: encodeDecl)
            }
            """

        guard let extensionDecl = ext.as(ExtensionDeclSyntax.self) else {
            return []
        }
        return [extensionDecl]
    }
}

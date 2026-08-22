import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct BaseModelNoWithExtraMacro: ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MacroError("@BaseModelNoWithExtra can only be applied to structs")
        }

        let typeName = structDecl.name.text
        let stored = collectStoredProperties(of: structDecl)
        let access = declAccessModifier(of: structDecl)

        if stored.isEmpty {
            let ext: DeclSyntax = """
                nonisolated extension \(raw: typeName): BaseModelNoWithExtra {
                }
                """
            guard let extensionDecl = ext.as(ExtensionDeclSyntax.self) else {
                return []
            }
            return [extensionDecl]
        }

        let codingKeysCases = stored.map { "case \($0.name)" }.joined(separator: "\n")
        // MARK: - Decode
        let decodable = stored.filter { !$0.isStatic && !$0.isImmutableWithDefault }
        let decodeBody = decodable.map { prop in
            if prop.isOptional {
                return "self.\(prop.name) = try container.decodeIfPresent(\(prop.typeName).self, forKey: .\(prop.name))"
            } else {
                return "self.\(prop.name) = try container.decode(\(prop.typeName).self, forKey: .\(prop.name))"
            }
        }.joined(separator: "\n")
        let decodeDecl = decodeBody.isEmpty ? "// No Decodable properties" : """
        let container = try decoder.container(keyedBy: CodingKeys.self)
        \(decodeBody)
        """
        // MARK: - Encode
        let encodable = stored.filter { !$0.isTransient }
        let encodeBody = encodable.map { prop in
            let accessor = prop.isStatic ? "Self" : "self"
            if prop.isOptional {
                return "try container.encodeIfPresent(\(accessor).\(prop.name), forKey: .\(prop.name))"
            } else {
                return "try container.encode(\(accessor).\(prop.name), forKey: .\(prop.name))"
            }
        }.joined(separator: "\n")
        let encodeDecl = encodeBody.isEmpty ? "// No Encodable properties" : """
        var container = encoder.container(keyedBy: CodingKeys.self)
        \(encodeBody)
        """
        // MARK: - CodingKey
        let codingKeysDecl = stored.isEmpty ? "" : """
            enum CodingKeys: String, CodingKey, CaseIterable {
            \(codingKeysCases)
            }
            """
        // MARK: - EXT
        let ext: DeclSyntax = """
            nonisolated extension \(raw: typeName): BaseModelNoWithExtra {
                \(raw: codingKeysDecl)

                \(raw: access)init(from decoder: Decoder) throws {
                    \(raw: decodeDecl)
            
                    try self.after()
                }

                \(raw: access)func encode(to encoder: Encoder) throws {
                    \(raw: encodeDecl)
                }
            }
            """

        guard let extensionDecl = ext.as(ExtensionDeclSyntax.self) else {
            return []
        }
        return [extensionDecl]
    }
}

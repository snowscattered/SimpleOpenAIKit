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

        // Skip when the struct declares its own init, otherwise overloads become ambiguous.
        guard !structDecl.memberBlock.members.contains(where: { $0.decl.is(InitializerDeclSyntax.self) }) else {
            return [extraProperty]
        }

        // MARK: - Init
        let stored = collectStoredProperties(of: structDecl).filter { !$0.isStatic && !$0.isImmutableWithDefault }
        var initParams = stored.map { prop -> String in
            prop.isOptional ? "\(prop.name): \(prop.typeName)? = nil" : "\(prop.name): \(prop.typeName)"
        }
        var initBody = stored.map { "self.\($0.name) = \($0.name)" }
        // `extra` is added by this macro, so it becomes the last parameter.
        initParams.append("extra: [String : BaseType] = [:]")
        initBody.append("self.extra = extra")

        let initDecl: DeclSyntax = """
            \(raw: access)init(
                \(raw: initParams.joined(separator: ",\n"))
            ) {
                \(raw: initBody.joined(separator: "\n"))
            }
            """
        return [extraProperty, initDecl]
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
        
        let decodeFilterPart = stored.isEmpty ? "self.extra = dict" : """
            let keys = Set(CodingKeys.allCases.map { $0.rawValue })
            self.extra = dict.filter { !keys.contains($0.key) }
            """
        // MARK: - EXT
        let ext: DeclSyntax = """
            nonisolated extension \(raw: typeName): BaseModelWithExtra {
                \(raw: codingKeysDecl)

                \(raw: access)init(from decoder: Decoder) throws {
                    \(raw: decodeDecl)
            
                    let c = try decoder.singleValueContainer()
                    let dict = try c.decode([String: BaseType].self)
                    \(raw: decodeFilterPart)

                    try self.after()
                }

                \(raw: access)func encode(to encoder: Encoder) throws {
                    \(raw: encodeDecl)

                    var c = encoder.singleValueContainer()
                    let dict = extra
                    try c.encode(dict)
                }
            }
            """

        guard let extensionDecl = ext.as(ExtensionDeclSyntax.self) else {
            return []
        }
        return [extensionDecl]
    }
}

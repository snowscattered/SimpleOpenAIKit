// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that generates `BaseModel` conformance for enums where one case
/// wraps a single value and another wraps an array of the same element type.
@attached(extension, conformances: BaseModel, names: named(init(from:)), named(encode(to:)))
public macro SingleOrArray() = #externalMacro(module: "SimpleCodableMacroPlugin", type: "SingleOrArrayMacro")

/// Automatically adds `BaseModel` conformance to an enum with constant cases (no associated values).
/// The macro generates `init(from:)` to decode plain JSON literals (strings or numbers) into the matching enum case.
/// - Note: The enum must have no associated values and its raw type (if any) must be `String` or `Int`.
@attached(extension, conformances: BaseModel, names: named(init(from:)))
public macro CodableLiteral() = #externalMacro(module: "SimpleCodableMacroPlugin", type: "CodableLiteralMacro")

/// Generates `BaseModel` conformance for a string-literal enum that declares `case other(String)`.
/// - Note: The enum must not have a raw type, and plain cases must have no associated values.
@attached(extension, conformances: BaseModel, names: named(rawValue), named(init(from:)), named(encode(to:)))
public macro CodableStringLiteralWithOther() = #externalMacro(module: "SimpleCodableMacroPlugin", type: "CodableStringLiteralWithOtherMacro")

/// A macro that generates Codable conformance for enums by trying to decode each case type in order.
/// First successful decode wins.
@attached(extension, conformances: BaseModel, names: named(init(from:)), named(encode(to:)))
public macro CodableTraversal() = #externalMacro(module: "SimpleCodableMacroPlugin", type: "CodableTraversalMacro")

/// A macro that generates Codable conformance for enums with associated values,
/// dispatching on a `type` field to decode/encode the correct case.
@attached(extension, conformances: BaseModel, names: named(CodingKeys), named(init(from:)), named(encode(to:)))
public macro CodableByConstant(
    field: String = "type",
    nilCase: String? = nil,
    still: Bool? = nil,
    defaultCase: String? = nil
) = #externalMacro(module: "SimpleCodableMacroPlugin", type: "CodableByConstantMacro")

/// Like `CodableByConstant`, but also tries to decode a top-level single value
/// into the case named by `singleCase` before falling back to the keyed container.
@attached(extension, conformances: BaseModel, names: named(CodingKeys), named(init(from:)), named(encode(to:)))
public macro CodableByConstantAndSingle(
    field: String = "type",
    singleCase: String,
    defaultCase: String? = nil,
) = #externalMacro(module: "SimpleCodableMacroPlugin", type: "CodableByConstantAndSingleMacro")

/// Supplies one or more field values used to decode an enum case.
/// Apply this marker to a case handled by `CodableByConstant` or
/// `CodableByConstantAndSingle` to avoid requiring a static field on the
/// associated value's type.
@attached(peer)
public macro MultiConstant(_ values: String...) = #externalMacro(module: "SimpleCodableMacroPlugin", type: "MultiConstMacro")
@attached(peer)
public macro MultiConstant(_ values: [String]) = #externalMacro(module: "SimpleCodableMacroPlugin", type: "MultiConstMacro")

/// Marker attribute for properties inside a `@BaseModelWithExtra` or `@BaseModelNoWithExtra` struct.
/// The annotated property will be decoded but skipped during encoding.
@attached(peer)
public macro transient() = #externalMacro(module: "SimpleCodableMacroPlugin", type: "TransientMacro")

/// A macro that generates a `public` memberwise initializer for a struct or root class.
/// Properties that are `static` or `let` with an initial value are skipped.
@attached(member, names: named(init))
public macro PublicInit() = #externalMacro(module: "SimpleCodableMacroPlugin", type: "PublicInitMacro")

/// A macro that generates a `nonisolated extension` conforming to `BaseModelNoWithExtra`.
/// The annotated type must already be `Codable & Sendable`.
/// Combine it with `@PublicInit` to get the memberwise `init`.
@attached(extension, conformances: BaseModelNoWithExtra, names: named(CodingKeys), named(init(from:)), named(encode(to:)))
public macro BaseModelNoWithExtra() = #externalMacro(module: "SimpleCodableMacroPlugin", type: "BaseModelNoWithExtraMacro")

/// A macro applied to a struct to generate `BaseModel: Codable & Sendable` conformance
/// with an `extra` dictionary capturing unknown JSON keys.
/// `extra` is a decode-only fallback and is not part of the generated `init`.
@attached(member, names: named(extra))
@attached(extension, conformances: BaseModelWithExtra, names: named(CodingKeys), named(init(from:)), named(encode(to:)))
public macro BaseModelWithExtra() = #externalMacro(module: "SimpleCodableMacroPlugin", type: "BaseModelWithExtraMacro")

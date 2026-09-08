//
//  ToolMacros.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/6/26.
//

@_exported import SimpleCodableMacro

/// Generates `static var ArgumentSchema: [String: BaseType]` on a struct: the root `object` JSON Schema
/// of an OpenAI function tool, i.e. `{"type": "object", "properties": {...}, "required": [...],
/// "additionalProperties": false}`. `extra` is merged on top when supplied, but `additionalProperties`
/// remains `false`.
///
/// Every property is described whether or not it carries a `@*ToolArgument` macro. Without one the
/// schema is inferred from the Swift type: `String`, integers, floats and `Bool` become their JSON
/// type, arrays become `array` plus `items`, one level of `Optional` is unwrapped (and stays out of
/// `required`), and any other named type is inlined as its own `ArgumentSchema`, so it has to carry
/// `@MainArgument`, `@ReferArgument`, `@EnumToolArgument` or `@AnyOfToolArgument` itself. `required` holds every
/// non-optional property.
///
/// A property that carries `@ReferToolArgument` is written as a `$ref` instead, and this object's
/// `"$def"` entry holds the definitions it references.
///
/// The `MainArgument` conformance is added automatically.
@attached(member, names: named(ArgumentSchema))
@attached(extension, conformances: MainArgument)
public macro MainArgument(extra: [String: BaseType]? = nil) = #externalMacro(module: "SimpleOpenAIKitMacroPlugin", type: "MainArgumentMacro")

/// Generates `static var ArgumentSchema: [String: BaseType]` on a struct used as a `$def` definition.
/// The schema has the same object shape as `@MainArgument`, including `"additionalProperties": false`,
/// but does not generate a nested `"$def"` block. Use `@ReferToolArgument` on properties that should be
/// written as `$ref`.
///
/// The `ReferArgument` conformance is added automatically.
@attached(member, names: named(ArgumentSchema))
@attached(extension, conformances: ReferArgument)
public macro ReferArgument() = #externalMacro(module: "SimpleOpenAIKitMacroPlugin", type: "ReferArgumentMacro")

/// Describes a `string` value. Strict mode validates `pattern` and `format` (`email`, `hostname`,
/// `ipv4`, `ipv6`, `uuid`); `minLength` and `maxLength` are part of JSON Schema but are not supported
/// in strict mode. Only the labels that are spelled out land in the schema. Attaching it to a value
/// whose Swift type is not a `string` one is an error.
@attached(peer)
public macro StringToolArgument(
    description: String? = nil,
    format: String? = nil,
    pattern: String? = nil,
    minLength: Int? = nil,
    maxLength: Int? = nil
) = #externalMacro(module: "SimpleOpenAIKitMacroPlugin", type: "StringToolArgumentMacro")

/// Describes a `number` value, or an `integer` one when the Swift type is integral. `default`
/// suggests a starting value and the bounds are `minimum`, `maximum`, `exclusiveMinimum` (not less
/// than), `exclusiveMaximum` (not greater than) and `multipleOf`. Attaching it to a value whose Swift
/// type is neither is an error.
@attached(peer)
public macro NumberToolArgument(
    description: String? = nil,
    `default`: Double? = nil,
    minimum: Double? = nil,
    maximum: Double? = nil,
    exclusiveMinimum: Double? = nil,
    exclusiveMaximum: Double? = nil,
    multipleOf: Double? = nil
) = #externalMacro(module: "SimpleOpenAIKitMacroPlugin", type: "NumberToolArgumentMacro")

/// Describes a `boolean` value, which has no constraint of its own beyond `description`. Attaching it
/// to a value whose Swift type is not a `boolean` one is an error.
@attached(peer)
package macro BooleanToolArgument(
    description: String? = nil
) = #externalMacro(module: "SimpleOpenAIKitMacroPlugin", type: "BooleanToolArgumentMacro")

/// Describes an `array` value. `items` is the schema inferred from the Swift element type, so a named
/// element has to carry its own schema macro. `minItems` and `maxItems` are part of JSON Schema but are
/// not supported in strict mode. Attaching it to a value whose Swift type is not an array is an error.
@attached(peer)
public macro ArrayToolArgument(
    description: String? = nil,
    minItems: Int? = nil,
    maxItems: Int? = nil
) = #externalMacro(module: "SimpleOpenAIKitMacroPlugin", type: "ArrayToolArgumentMacro")

/// Describes a value by reference: `{"$ref": "#/$def/TypeName"}` pointing at a type annotated with
/// `@ReferArgument`, whose definition the enclosing schema writes into its `"$def"` entry, so one
/// definition can serve several properties. `description` is the only key a reference adds of its own,
/// which strict mode allows next to `$ref`. An array of them is `{"type": "array", "items": {"$ref":
/// ...}}`, where `description` describes the array.
///
/// Attaching it to a value whose Swift type is built from a scalar is an error. Attaching it to a type
/// that has no schema macro of its own is an error too, reported where the enclosing schema writes its
/// `"$def"`: that entry names `TypeName.ArgumentSchema`, which only exists on a type carrying one of
/// them.
@attached(peer)
public macro ReferToolArgument(
    description: String? = nil
) = #externalMacro(module: "SimpleOpenAIKitMacroPlugin", type: "ReferToolArgumentMacro")

/// Generates `static var ArgumentSchema: [String: BaseType]` on a raw-value enum: `{"type": ...,
/// "enum": [...]}` built from its raw values, where the JSON type is the raw type's own — `String`
/// gives `string`, any integer type gives `integer`, and `Double` and `Float` give `number`. A case
/// without an explicit raw value falls back to its name (`String`) or to the
/// value after the case before it (`Int`), exactly like Swift's own implicit raw values.
///
/// The `EnumArgument` conformance is added automatically.
@attached(member, names: named(ArgumentSchema))
@attached(extension, conformances: EnumArgument)
public macro EnumToolArgument() = #externalMacro(module: "SimpleOpenAIKitMacroPlugin", type: "EnumToolArgumentMacro")

/// Generates `static var ArgumentSchema: [String: BaseType]` on an enum: `{"anyOf": [...]}` with one
/// entry per case, each of them the schema of that case's associated value. A case may carry a
/// `@*ToolArgument` macro to describe itself, e.g. `@StringToolArgument(description: "DA")`.
///
/// The `AnyOfArgument` conformance is added automatically.
@attached(member, names: named(ArgumentSchema))
@attached(extension, conformances: AnyOfArgument)
public macro AnyOfToolArgument() = #externalMacro(module: "SimpleOpenAIKitMacroPlugin", type: "AnyOfToolArgumentMacro")

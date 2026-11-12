import Foundation
import Testing
import SimpleCodableMacro

@CodableByConstant(
    field: "role",
    nilCase: "nilValue",
    still: true,
    defaultCase: "unknown"
)
enum FeatureRoute {
    @MultiConstant("developer", "dev")
    case developer(SharedPayload)

    @MultiConstant("custom")
    case custom(SharedPayload)

    @MultiConstant("nilValue")
    case nilValue(EmptyPayload)

    case unknown(SharedPayload)
}

@CodableByConstant
enum StrictRoute {
    @MultiConstant("developer")
    case developer(SharedPayload)
}

@CodableByConstantAndSingle(
    field: "role",
    singleCase: "single",
    defaultCase: "unknown"
)
enum RoutedMessage {
    @MultiConstant("staff", "developer")
    case developer(SharedPayload)

    @MultiConstant("custom")
    case custom(SharedPayload)

    case single(String)
    case unknown(SharedPayload)
}

func featureRouteParts(
    _ route: FeatureRoute
) -> (route: String, role: String?, content: String?) {
    switch route {
    case .developer(let payload):
        return ("developer", payload.role, payload.content)
    case .custom(let payload):
        return ("custom", payload.role, payload.content)
    case .nilValue:
        return ("nilValue", nil, nil)
    case .unknown(let payload):
        return ("unknown", payload.role, payload.content)
    }
}

func routedMessageParts(
    _ message: RoutedMessage
) -> (route: String, role: String?, content: String?) {
    switch message {
    case .developer(let payload):
        return ("developer", payload.role, payload.content)
    case .custom(let payload):
        return ("custom", payload.role, payload.content)
    case .single(let value):
        return ("single", nil, value)
    case .unknown(let payload):
        return ("unknown", payload.role, payload.content)
    }
}

@Suite
struct CodableByConstantTests {
    @Test
    func combinedRouteDecodesRegularAliasesAndFallback() throws {
        let developer = try TestJSON.decode(
            FeatureRoute.self,
            from: #"{"role":"dev","content":"developer"}"#
        )
        let custom = try TestJSON.decode(
            FeatureRoute.self,
            from: #"{"role":"custom","content":"custom"}"#
        )
        let unknown = try TestJSON.decode(
            FeatureRoute.self,
            from: #"{"role":"future","content":"unknown"}"#
        )

        #expect(featureRouteParts(developer) == ("developer", "dev", "developer"))
        #expect(featureRouteParts(custom) == ("custom", "custom", "custom"))
        #expect(featureRouteParts(unknown) == ("unknown", "future", "unknown"))
        print(developer)
        print(custom)
        print(unknown)
    }

    @Test
    func combinedRouteHandlesNilAndExplicitNilConstant() throws {
        let missing = try TestJSON.decode(
            FeatureRoute.self,
            from: #"{"content":"missing"}"#
        )
        let null = try TestJSON.decode(
            FeatureRoute.self,
            from: #"{"role":null,"content":"null"}"#
        )
        let explicit = try TestJSON.decode(
            FeatureRoute.self,
            from: #"{"role":"nilValue","content":"explicit"}"#
        )

        #expect(missing == .nilValue(EmptyPayload()))
        #expect(null == .nilValue(EmptyPayload()))
        #expect(explicit == .nilValue(EmptyPayload()))
        print(missing)
        print(null)
        print(explicit)
    }

    @Test
    func combinedRouteEncodesAndExposesConfiguredField() throws {
        let developer = FeatureRoute.developer(
            SharedPayload(role: "dev", content: "developer")
        )
        let unknown = FeatureRoute.unknown(
            SharedPayload(role: "future", content: "unknown")
        )
        let developerJSON = try TestJSON.object(from: developer)
        let nilJSON = try TestJSON.object(from: FeatureRoute.nilValue(.init()))

        #expect(developer.role == "developer")
        #expect(unknown.role == "future")
        #expect(developerJSON["role"] != nil)
        #expect(nilJSON.isEmpty)
        print(developer)
        print(unknown)
        print(try TestJSON.string(from: developer))
    }

    @Test
    func unknownTypeThrowsWithoutFallbackCase() {
        #expect(throws: (any Error).self) {
            try TestJSON.decode(
                StrictRoute.self,
                from: #"{"type":"future","role":"future","content":"unknown"}"#
            )
        }
    }

    @Test
    func constantAndSingleDecodesSingleKeyedAndFallbackShapes() throws {
        let single = try TestJSON.decode(
            RoutedMessage.self,
            from: #""raw""#
        )
        let developer = try TestJSON.decode(
            RoutedMessage.self,
            from: #"{"role":"staff","content":"developer"}"#
        )
        let custom = try TestJSON.decode(
            RoutedMessage.self,
            from: #"{"role":"custom","content":"custom"}"#
        )
        let unknown = try TestJSON.decode(
            RoutedMessage.self,
            from: #"{"role":"future","content":"unknown"}"#
        )

        #expect(single == .single("raw"))
        #expect(routedMessageParts(developer) == ("developer", "staff", "developer"))
        #expect(routedMessageParts(custom) == ("custom", "custom", "custom"))
        #expect(routedMessageParts(unknown) == ("unknown", "future", "unknown"))
        print(single)
        print(developer)
        print(custom)
        print(unknown)
    }

    @Test
    func constantAndSingleEncodesEveryShape() throws {
        let single = try TestJSON.string(from: RoutedMessage.single("raw"))
        let developer = try TestJSON.object(
            from: RoutedMessage.developer(
                .init(role: "staff", content: "developer")
            )
        )
        let unknown = try TestJSON.object(
            from: RoutedMessage.unknown(
                .init(role: "future", content: "unknown")
            )
        )

        #expect(single == #""raw""#)
        #expect(developer["content"] != nil)
        #expect(unknown["role"] != nil)
        print(single)
        print(try TestJSON.string(from: RoutedMessage.developer(
            .init(role: "staff", content: "developer")
        )))
    }
}

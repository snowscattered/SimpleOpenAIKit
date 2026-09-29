//
//  SessionProtocol.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

/// The HTTP verb used by a built request.
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case update = "UPDATE"
    case delete = "DELETE"
}

/// The transport layer between an API resource and the network.
///
/// A session owns nothing but behaviour: it builds the `URLRequest`, runs it with the retry
/// policy the provider wants, and converts a raw `NetworkError` into the provider's public
/// error type. One stateless `shared` value serves every resource of that provider.
public protocol SessionProtocol {
    /// The option bag the resources pass down on each call.
    associatedtype ClientOption: APIClientOption, ~Copyable
    /// The single instance used by all resources of this provider.
    static var shared: Self { get }
    /// Build a `URLRequest` from a URL, payload and per-call overrides.
    ///
    /// - Parameters:
    ///   - url: Endpoint URL, already resolved against `base_url`.
    ///   - payload: Request body; sent as query items when `method` is `.get`.
    ///   - requestOptions: Per-call header/query/body/timeout overrides.
    ///   - clientOption: Credentials and defaults for this call.
    ///   - method: HTTP verb to use.
    ///   - hasFile: Encode the body as `multipart/form-data` instead of JSON.
    /// - Returns: A request that is ready to be sent.
    func getRequest<Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: borrowing ClientOption,
        method: HTTPMethod,
        hasFile: Bool,
    ) throws -> URLRequest
    /// Decide whether a thrown error is worth retrying; also used as the retry predicate.
    func retryErrorHandler(error: any Error) -> Bool
    /// Convert a raw `NetworkError` into the provider's public error type.
    func wrapError(error: any Error) -> any Error
}
public extension SessionProtocol {
    /// Default policy: retry every error.
    func retryErrorHandler(error: any Error) -> Bool { return true }
    /// Default policy: surface the error unchanged.
    func wrapError(error: any Error) -> any Error { return error }
    /// Merge client defaults with per-call overrides, then encode the body.
    ///
    /// Query items come from `clientOption.query` plus `extra_query`, and for a GET the payload's
    /// JSON keys are folded in too. The body is multipart when `hasFile` is set, otherwise JSON,
    /// always merged with `extra_body`. `requestOptions.timeout` wins over `clientOption.timeout`.
    func getRequest<Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: borrowing ClientOption,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) throws -> URLRequest {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }
        // Query - start with client.query as defaults
        var query = clientOption.query
        if method == .get {
            let payloadMap = try? JSONDecoder().decode(Query.self, from: try JSONEncoder().encode(payload))
            if let map = payloadMap {
                query = query | map
            }
        }
        if let extraQuery = requestOptions?.extra_query, !extraQuery.isEmpty {
            query = query | extraQuery
        }
        components.queryItems = query.isEmpty ? nil : query.toURLQueryItems()
        guard let finalURL = components.url else { throw URLError(.badURL) }
        var request = URLRequest(url: finalURL)
        // Header - start with client.headers as defaults
        var headers = clientOption.headers
        if let extra = requestOptions?.extra_headers, !extra.isEmpty {
            headers = headers | extra
        }
        request.allHTTPHeaderFields = headers
        // Body
        if method != .get {
            if hasFile {
                let encoder = MultipartFormDataEncodeContainer()
                try encoder.encode(payload)
                if let extraBody = requestOptions?.extra_body, !extraBody.isEmpty {
                    try encoder.encode(extraBody)
                }
                request.httpBodyStream = encoder.serialize
                request.allHTTPHeaderFields?["Content-Type"] = "multipart/form-data; boundary=\(encoder.boundary)"
            } else {
                var payloadMap = (try? JSONDecoder().decode(Body.self, from: try JSONEncoder().encode(payload))) ?? [:]
                if let extraBody = requestOptions?.extra_body, !extraBody.isEmpty {
                    payloadMap = payloadMap | extraBody
                }
                let body = try JSONEncoder().encode(payloadMap)
                request.httpBody = body
            }
        } else {
            if let extraBody = requestOptions?.extra_body, !extraBody.isEmpty {
                let body = try JSONEncoder().encode(extraBody)
                request.httpBody = body
            }
        }
        // Other
        request.httpMethod = method.rawValue
        request.timeoutInterval = clientOption.timeout
        if let timeout = requestOptions?.timeout {
            request.timeoutInterval = timeout
        }
        return request
    }
    
    /// Blocking call that decodes a single response, retrying as allowed by the session.
    ///
    /// - Returns: The decoded response body.
    /// - Throws: The provider's wrapped error when the request fails or the body cannot be decoded.
    func SyncResponse<T: Decodable & Sendable, Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: borrowing ClientOption,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) throws -> T {
        let request = try getRequest(
            url,
            payload: payload,
            requestOptions: requestOptions,
            clientOption: clientOption,
            method: method,
            hasFile: hasFile,
        )
        do {
            return try syncResponse(request: request, maxRetries: clientOption.max_retries, shouldRetry: retryErrorHandler)
        } catch { throw wrapError(error: error) }
    }
    /// Blocking call that returns a stream of decoded chunks.
    ///
    /// Only the connection attempt is retried; chunks already handed out are never replayed.
    /// - Returns: A stream that yields each decoded event, ending at `[DONE]`.
    func SyncStreamResponse<T: Decodable & Sendable, Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: borrowing ClientOption,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) throws -> SyncThrowingStream<T, any Error> {
        let request = try getRequest(
            url,
            payload: payload,
            requestOptions: requestOptions,
            clientOption: clientOption,
            method: method,
            hasFile: hasFile,
        )
        do {
            return try syncStreamResponse(request: request, maxRetries: clientOption.max_retries, shouldRetry: retryErrorHandler)
        } catch { throw wrapError(error: error) }
    }
    
    /// Awaitable call that decodes a single response, retrying as allowed by the session.
    ///
    /// - Returns: The decoded response body.
    /// - Throws: The provider's wrapped error when the request fails or the body cannot be decoded.
    func AsyncResponse<T: Decodable & Sendable, Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: borrowing ClientOption,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) async throws -> T {
        let request = try getRequest(
            url,
            payload: payload,
            requestOptions: requestOptions,
            clientOption: clientOption,
            method: method,
            hasFile: hasFile,
        )
        do {
            return try await asyncResponse(request: request, maxRetries: clientOption.max_retries, shouldRetry: retryErrorHandler)
        } catch { throw wrapError(error: error) }
    }
    /// Awaitable call that returns a stream of decoded chunks.
    ///
    /// Only the connection attempt is retried; chunks already handed out are never replayed.
    /// - Returns: A stream that yields each decoded event, ending at `[DONE]`.
    func AsyncStreamResponse<T: Decodable & Sendable, Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: borrowing ClientOption,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) async throws -> AsyncThrowingStream<T, any Error> {
        let request = try getRequest(
            url,
            payload: payload,
            requestOptions: requestOptions,
            clientOption: clientOption,
            method: method,
            hasFile: hasFile,
        )
        do {
            return try await asyncStreamResponse(request: request, maxRetries: clientOption.max_retries, shouldRetry: retryErrorHandler)
        } catch { throw wrapError(error: error) }
    }
    
    /// Open a websocket task against `url`; the payload is not sent as a body.
    ///
    /// The request is always built with `.get` so that headers and query items still apply.
    /// - Returns: A task that has not been resumed yet.
    func WebSocket<Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: borrowing ClientOption,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) throws -> URLSessionWebSocketTask {
        let request = try getRequest(
            url,
            payload: nil as Payload?,
            requestOptions: requestOptions,
            clientOption: clientOption,
            method: .get,
        )
        return URLSession.shared.webSocketTask(with: request)
    }
}

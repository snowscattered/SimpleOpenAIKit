//
//  SessionProtocol.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case update = "UPDATE"
    case delete = "DELETE"
}
public protocol SessionProtocol {
    associatedtype ClientOption: APIClientOption
    static var shared: Self { get }
    func getRequest<Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: ClientOption,
        method: HTTPMethod,
        hasFile: Bool,
    ) throws -> URLRequest
    func retryErrorHandler(error: Error) -> Bool
    func wrapError(error: Error) -> Error
}
public extension SessionProtocol {
    func retryErrorHandler(error: Error) -> Bool { return true }
    func wrapError(error: Error) -> Error { return error }
    func getRequest<Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: ClientOption,
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
    
    func SyncResponse<T: Decodable & Sendable, Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: ClientOption,
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
    func SyncStreamResponse<T: Decodable & Sendable, Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: ClientOption,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) throws -> SyncThrowingStream<T, Error> {
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
    
    func AsyncResponse<T: Decodable & Sendable, Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: ClientOption,
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
    func AsyncStreamResponse<T: Decodable & Sendable, Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: ClientOption,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) async throws -> AsyncThrowingStream<T, Error> {
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
    
    func WebSocket<Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        clientOption: ClientOption,
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

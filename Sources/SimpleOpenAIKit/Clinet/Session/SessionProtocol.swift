//
//  SessionProtocol.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/12/26.
//

import Foundation

protocol SessionProtocol {
    associatedtype Client: APIClient
    static var shared: Self { get }
    func getRequest<Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        client: Client,
        method: HTTPMethod,
        hasFile: Bool,
    ) throws -> URLRequest
    func retryErrorHandler(error: Error) -> Bool
    func wrapError(error: Error) -> Error
}
extension SessionProtocol {
    func getRequest<Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        client: Client,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) throws -> URLRequest {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }
        // Query - start with client.query as defaults
        var query = client.query
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
        var headers = client.headers
        if let extra = requestOptions?.extra_headers, !extra.isEmpty {
            headers = headers | extra
        }
        request.allHTTPHeaderFields = headers
        // Body
        var body: Data? = nil
        if method != .get {
            if hasFile {
                let encoder = MultipartFormDataEncodeContainer()
                try encoder.encode(payload)
                if let extra = requestOptions?.extra_body, !extra.isEmpty {
                    try encoder.encode(extra)
                }
                request.httpBodyStream = encoder.serialize
                request.allHTTPHeaderFields?["Content-Type"] = "multipart/form-data; boundary=\(encoder.boundary)"
            } else {
                var payloadMap = (try? JSONDecoder().decode(Body.self, from: try JSONEncoder().encode(payload))) ?? [:]
                if let extra = requestOptions?.extra_body, !extra.isEmpty {
                    payloadMap = payloadMap | extra
                }
                body = try JSONEncoder().encode(payloadMap)
                request.httpBody = body
            }
        }
        // Other
        request.httpMethod = method.rawValue
        request.timeoutInterval = client.timeout
        if let timeout = requestOptions?.timeout {
            request.timeoutInterval = timeout
        }
        return request
    }
    
    func SyncResponse<T: Decodable & Sendable, Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        client: Client,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) throws -> T {
        let request = try getRequest(
            url,
            payload: payload,
            requestOptions: requestOptions,
            client: client,
            method: method,
            hasFile: hasFile,
        )
        do {
            return try syncResponse(request: request, maxRetries: client.max_retries, shouldRetry: retryErrorHandler)
        } catch { throw wrapError(error: error) }
    }
    func SyncStreamResponse<T: Decodable & Sendable, Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        client: Client,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) throws -> SyncThrowingStream<T, Error> {
        let request = try getRequest(
            url,
            payload: payload,
            requestOptions: requestOptions,
            client: client,
            method: method,
            hasFile: hasFile,
        )
        do {
            return try syncStreamResponse(request: request, maxRetries: client.max_retries, shouldRetry: retryErrorHandler)
        } catch { throw wrapError(error: error) }
    }
    
    func AsyncResponse<T: Decodable & Sendable, Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        client: Client,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) async throws -> T {
        let request = try getRequest(
            url,
            payload: payload,
            requestOptions: requestOptions,
            client: client,
            method: method,
            hasFile: hasFile,
        )
        do {
            return try await asyncResponse(request: request, maxRetries: client.max_retries, shouldRetry: retryErrorHandler)
        } catch { throw wrapError(error: error) }
    }
    func AsyncStreamResponse<T: Decodable & Sendable, Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        client: Client,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) async throws -> AsyncThrowingStream<T, Error> {
        let request = try getRequest(
            url,
            payload: payload,
            requestOptions: requestOptions,
            client: client,
            method: method,
            hasFile: hasFile,
        )
        do {
            return try await asyncStreamResponse(request: request, maxRetries: client.max_retries, shouldRetry: retryErrorHandler)
        } catch { throw wrapError(error: error) }
    }
    
    func WebSocket<Payload: Encodable>(
        _ url: URL,
        payload: Payload?,
        requestOptions: RequestOptions?,
        client: Client,
        method: HTTPMethod,
        hasFile: Bool = false,
    ) throws -> URLSessionWebSocketTask {
        let request = try getRequest(
            url,
            payload: nil as Payload?,
            requestOptions: requestOptions,
            client: client,
            method: .get,
        )
        return URLSession.shared.webSocketTask(with: request)
    }
}

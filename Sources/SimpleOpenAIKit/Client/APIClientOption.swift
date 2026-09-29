//
//  APIClient.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/31/26.
//

import Foundation

/// The immutable configuration shared by every request a client makes.
///
/// Conforming types supply credentials, base URL, timeout, retry budget and default header/query values.
public protocol APIClientOption: ~Copyable {
    /// Bearer token used by the `Authorization` header.
    var api_key: String { get }
    /// Root URL that every resource path is appended to.
    var base_url: URL { get }
    /// Per-request timeout, in seconds.
    var timeout: TimeInterval { get }
    /// Extra attempts allowed after the first failure.
    var max_retries: Int { get }

    /// Headers applied to every request, auth included.
    var headers: Header { get }
    /// Query items applied to every request.
    var query: Query { get }
}

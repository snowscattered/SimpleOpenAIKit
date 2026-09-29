//
//  TypeSafeSyncAPIResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

/// Namespaces of the blocking TypeSafe client.
public enum TypeSafeSyncAPIResource {

    // MARK: SystemOne
    /// `/v1/systemone`: the System One judgement endpoint.
    public struct SystemOneSyncResource: ~Copyable {
        let clientOption: TypeSafeClientOption
        init(_ clientOption: TypeSafeClientOption) { self.clientOption = clientOption }
    }

    // MARK: Model
    /// `/v1/models`: the models exposed by the TypeSafe API.
    public struct ModelsSyncResource: ~Copyable {
        let clientOption: TypeSafeClientOption
        init(_ clientOption: TypeSafeClientOption) { self.clientOption = clientOption }
    }
}

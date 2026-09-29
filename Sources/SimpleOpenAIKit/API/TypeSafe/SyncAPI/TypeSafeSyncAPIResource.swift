//
//  TypeSafeSyncAPIResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

public enum TypeSafeSyncAPIResource {

    // MARK: SystemOne
    public struct SystemOneSyncResource: ~Copyable {
        let clientOption: TypeSafeClientOption
        init(_ clientOption: TypeSafeClientOption) { self.clientOption = clientOption }
    }

    // MARK: Model
    public struct ModelsSyncResource: ~Copyable {
        let clientOption: TypeSafeClientOption
        init(_ clientOption: TypeSafeClientOption) { self.clientOption = clientOption }
    }
}

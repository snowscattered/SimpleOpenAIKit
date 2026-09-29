//
//  TypeSafeAsyncAPIResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

public enum TypeSafeAsyncAPIResource {

    // MARK: SystemOne
    public struct SystemOneAsyncResource: ~Copyable {
        let clientOption: TypeSafeClientOption
        init(_ clientOption: TypeSafeClientOption) { self.clientOption = clientOption }
    }

    // MARK: Model
    public struct ModelsAsyncResource: ~Copyable {
        let clientOption: TypeSafeClientOption
        init(_ clientOption: TypeSafeClientOption) { self.clientOption = clientOption }
    }
}

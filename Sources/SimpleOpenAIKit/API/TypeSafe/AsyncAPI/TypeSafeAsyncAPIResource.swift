//
//  TypeSafeAsyncAPIResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

public class TypeSafeAsyncAPIResource {
    let clientOption: TypeSafeClientOption
    init(_ clientOption: TypeSafeClientOption) {
        self.clientOption = clientOption
    }

    // MARK: SystemOne
    public final class SystemOneAsyncResource: TypeSafeAsyncAPIResource { }
    // MARK: Model
    public final class ModelsAsyncResource: TypeSafeAsyncAPIResource { }
}

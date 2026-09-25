//
//  TypeSafeSyncAPIResource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 9/23/26.
//

public class TypeSafeSyncAPIResource {
    let clientOption: TypeSafeClientOption
    init(_ clientOption: TypeSafeClientOption) {
        self.clientOption = clientOption
    }

    // MARK: SystemOne
    public final class SystemOneSyncResource: TypeSafeSyncAPIResource { }
    // MARK: Model
    public final class ModelsSyncResource: TypeSafeSyncAPIResource { }
}

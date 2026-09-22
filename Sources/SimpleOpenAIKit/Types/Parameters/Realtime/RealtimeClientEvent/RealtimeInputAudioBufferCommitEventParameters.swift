//
//  RealtimeInputAudioBufferCommitEvent.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation
import SimpleCodableMacro

@BaseModelNoWithExtra
@PublicInit
public struct RealtimeInputAudioBufferCommitEventParameters {
    public static let type: String = "input_audio_buffer.commit"
    public var event_id: String?
}

//
//  IOStreamError.swift
//  SimpleOpenAIKit
//
//  Created by snow on 7/14/26.
//

import Foundation

enum IOStreamError: Error {
    case invalidURL
    case invalidData
    case creationFailed
    case readFailed
    case writeFailed
}

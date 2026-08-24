//
//  MessageSource.swift
//  SimpleOpenAIKit
//
//  Created by snow on 5/22/26.
//

import Foundation
import SimpleCodableMacro

@CodableByConstant
public enum MessageSource {
    case base64(MessageBase64ImageSource)
    case url(MessageURLSource)
}

@CodableByConstant
@nonexhaustive
public enum MessageDocumentBlockSource {
    case base64pdf(MessageBase64PDFSource)
    case plaintext(MessagePlainTextSource)
    case content_block(MessageContentBlockSource)
    case url_pdf(MessageURLPDFSource)
}

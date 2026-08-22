//
//  ResponseAnnotation.swift
//  SimpleOpenAIKit
//
//  Created by snow on 6/11/26.
//
import Foundation
import SimpleCodableMacro

@CodableByConstant
public enum ResponseAnnotation {
    case file_citation(ResponseAnnotationFileCitation)
    case file_path(ResponseAnnotationFilePath)
    case container_file_citation(ResponseAnnotationContainerFileCitation)
    case url_citation(ResponseAnnotationURLCitation)
}

//
//  ParameterEncoding.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    func encode(
        urlRequest: inout URLRequest,
        with parameters: Parameters
    ) throws
}

extension ParameterEncoder {
    func createBoundary() -> String {
        return UUID().uuidString
    }
    
    func lineBreak() -> String {
        return "\r\n"
    }
}



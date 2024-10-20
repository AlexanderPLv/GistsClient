//
//  GetRequestEncoder.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import Foundation

struct GetRequestEncoder: ParameterEncoder {
    public func encode(
        urlRequest: inout URLRequest,
        with parameters: Parameters
    ) throws {
        urlRequest.setValue(
            RequestContentType.appJSON,
            forHTTPHeaderField: HTTPHeaderFields.accept
        )
    }
}

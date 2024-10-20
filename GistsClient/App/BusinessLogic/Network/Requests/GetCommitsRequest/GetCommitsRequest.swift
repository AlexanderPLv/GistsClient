//
//  GetCommitsRequest.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 21.10.2024.
//

import Foundation

protocol GetCommitsRequestFactory {
    func get(
        urlString: String?,
        completion: @escaping (Result<[Commit], Error>) -> Void
    )
}

final class GetCommitsRequest {
    let sessionManager: URLSession
    var serializer: DecodableSerializer<EndPoint.ModelType>
    let encoder: ParameterEncoder
    init(
        sessionManager: URLSession,
        serializer: DecodableSerializer<EndPoint.ModelType>,
        encoder: ParameterEncoder
    ) {
        self.sessionManager = sessionManager
        self.serializer = serializer
        self.encoder = encoder
    }
}

extension GetCommitsRequest: AbstractRequestFactory {
    typealias EndPoint = GetCommitsResource
    func request(withCompletion completion: @escaping (Result<[EndPoint.ModelType], Error>) -> Void) {}
}

extension GetCommitsRequest: GetCommitsRequestFactory {
    func get(
        urlString: String?,
        completion: @escaping (Result<[EndPoint.ModelType], Error>) -> Void
    ) {
        let route = GetCommitsResource(urlString: urlString)
        request(route, withCompletion: completion)
    }
}

//
//  GistsListRequestFactory.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import Foundation

protocol GistsListRequestFactory {
    func get(
        page: Int,
        completion: @escaping (Result<[Gist], Error>) -> Void
    )
}

final class GistsListRequest {
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

extension GistsListRequest: AbstractRequestFactory {
    typealias EndPoint = GetGistsListResource
    func request(withCompletion completion: @escaping (Result<[EndPoint.ModelType], Error>) -> Void) {}
}

extension GistsListRequest: GistsListRequestFactory {
    func get(
        page: Int,
        completion: @escaping (Result<[EndPoint.ModelType], Error>) -> Void
    ) {
        let route = GetGistsListResource(page: page)
        request(route, withCompletion: completion)
    }
}

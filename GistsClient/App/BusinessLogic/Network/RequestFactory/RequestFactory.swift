//
//  RequestFactory.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import Foundation

final class RequestFactory {
    
    static let shared = RequestFactory()
    
    private let commonSession: URLSession
    private let cache = Cache<String, Data>()
    
    private init() {
        self.commonSession = URLSession.shared
    }
}

extension RequestFactory {
    
    func makeImageRequest() -> GetImageRequestFactory {
        let request = GetImageRequest(
            sessionManager: commonSession,
            cache: cache
        )
        return request
    }
    
    func makeGistsListRequest() -> GistsListRequestFactory {
        let serializer = DecodableSerializer<Gist>()
        let encoder = GetRequestEncoder()
        let request = GistsListRequest(
            sessionManager: commonSession,
            serializer: serializer,
            encoder: encoder
        )
        return request
    }
}

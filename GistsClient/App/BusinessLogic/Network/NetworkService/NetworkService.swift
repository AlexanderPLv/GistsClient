//
//  NetworkService.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import UIKit

protocol NetworkService {
    func getGistsList(page: Int, completion: @escaping (Result<[Gist], Error>) -> Void)
}

protocol ImageLoader {
    func fetchImage(with urlString: String?) async -> (UIImage, String?)
}

final class NetworkServiceImpl: NetworkService, ImageLoader {
    
    static let shared = NetworkServiceImpl()
    private let requestFactory: RequestFactory
    private var cachedGists = [Gist]()
    
    private init(
        requestFactory: RequestFactory = RequestFactory.shared
    ) {
        self.requestFactory = requestFactory
    }
    
    func fetchImage(with urlString: String?) async -> (UIImage, String?) {
        let request = requestFactory.makeImageRequest()
        return await request.get(urlString: urlString)
    }
    
    func getGistsList(
        page: Int,
        completion: @escaping (Result<[Gist], Error>) -> Void
    ) {
        let request = requestFactory.makeGistsListRequest()
        request.get(page: page, completion: completion)
    }
}

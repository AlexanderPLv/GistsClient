//
//  GetImageListRequest.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import UIKit

protocol GetImageRequestFactory {
    func get(urlString: String?) async -> (UIImage, String?)
}

final class GetImageRequest {
    let sessionManager: URLSession
    let cache: Cache<String, Data>
    init(
        sessionManager: URLSession,
        cache: Cache<String, Data>
    ) {
        self.sessionManager = sessionManager
        self.cache = cache
    }
}

extension GetImageRequest: GetImageRequestFactory {
    func get(urlString: String?) async -> (UIImage, String?) {
        guard let urlString else {
            return (UIImage(resource: .imgPlaceholder), nil)
        }
        if let cachedDada = cache.value(forKey: urlString) {
            let image = UIImage(data: cachedDada)
            return (image ?? UIImage(resource: .imgPlaceholder), urlString)
        } else {
            guard let imageUrl = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: imageUrl),
                  let image = UIImage(data: data) else {
                return (UIImage(resource: .imgPlaceholder), urlString)
            }
            cache.insert(data, forKey: urlString)
            return (image, urlString)
        }
    }
}

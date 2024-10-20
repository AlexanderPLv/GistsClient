//
//  GistsCache.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 20.10.2024.
//

import Foundation

final class GistsCache {
    
    static let shared = GistsCache()
    private var cache = [Gist]()
    
    private init() {}
    
    func get() -> [Gist] {
        cache
    }
    
    func cache(_ gists: [Gist]) {
        cache.removeAll()
        cache = gists
    }
}

//
//  Commit.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 21.10.2024.
//

import Foundation

struct Commit: Decodable {
    let owner: GistOwner
    let committedAt: String
    
    enum CodingKeys: String, CodingKey {
        case owner = "user"
        case committedAt = "committed_at"
    }
}

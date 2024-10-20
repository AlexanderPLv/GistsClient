//
//  GistOwner.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 20.10.2024.
//

import Foundation

struct GistOwner: Decodable {
    let login: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}

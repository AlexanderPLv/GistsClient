//
//  Gist.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import Foundation

struct Gist: Decodable {
    let id: String
    let title: String?
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case title = "description"
    }
}

struct File: Codable {
    let filename: String
}

struct Owner: Decodable {
    let login: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}

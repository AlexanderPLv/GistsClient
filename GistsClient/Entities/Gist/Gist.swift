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
    let owner: GistOwner
    let commitsURL: String
    let files: [GistFile]
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case title = "description"
        case commitsURL = "commits_url"
        case files
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.owner = try container.decode(GistOwner.self, forKey: .owner)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.commitsURL = try container.decode(String.self, forKey: .commitsURL)
        var filesArray = [GistFile]()
        let dictionary = try container.decode([String: GistFile].self, forKey: .files)
        dictionary.forEach {
            filesArray.append($0.value)
        }
        self.files = filesArray
    }
}

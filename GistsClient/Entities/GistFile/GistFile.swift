//
//  GistFile.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 20.10.2024.
//

import Foundation

struct GistFile: Decodable {
    let filename: String
    let rawURL: String
    
    enum CodingKeys: String, CodingKey {
        case filename
        case rawURL = "raw_url"
    }
}

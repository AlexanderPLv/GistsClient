//
//  GetGistsListResource.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import Foundation

struct GetGistsListResource: EndPointType {
    typealias ModelType = Gist
    let host: BaseURL = .github
    let path: Path = .gists
    let httpMethod: HTTPMethod = .get
    let parameters: Parameters = [:]
    let page: Int
    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: "100")
        ]
    }
}

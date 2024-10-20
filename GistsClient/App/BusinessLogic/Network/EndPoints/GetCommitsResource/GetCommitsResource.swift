//
//  GetCommitsResource.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import Foundation

struct GetCommitsResource: EndPointType {
    typealias ModelType = Commit
    var host: BaseURL = .github
    var path: Path = .gists
    var httpMethod: HTTPMethod = .get
    var parameters: Parameters = [:]
    var queryItems: [URLQueryItem] = []
    var urlString: String?
}

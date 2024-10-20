//
//  EndPointType.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import Foundation

protocol EndPointType {
    associatedtype ModelType: Decodable
    var host: BaseURL { get }
    var path: Path { get }
    var httpMethod: HTTPMethod { get }
    var parameters: Parameters { get }
    var queryItems: [URLQueryItem] { get }
}

extension EndPointType {
    func url() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host.baseURL
        components.path = path.path
        components.queryItems = queryItems
        guard let url = components.url else { return nil }
        return url
    }
}

enum BaseURL {
    case github
}

extension BaseURL {
    var baseURL: String {
        switch self {
        case .github:
            return "api.github.com"
        }
    }
}

enum Path {
    case gists
}

extension Path {
    var path: String {
        switch self {
        case .gists:
            return "/gists"
        }
    }
}

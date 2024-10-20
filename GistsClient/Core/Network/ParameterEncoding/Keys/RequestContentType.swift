//
//  RequestContentType.swift
//  GistsClient
//
//  Created by Alexander Pelevinov on 16.10.2024.
//

import Foundation

struct RequestContentType {
    static let appJSON = "application/vnd.github+json"
    static let urlEncoded = "application/x-www-form-urlencoded"
    static let formData = "multipart/form-data"
    static let octetStream = "application/octet-stream"
}

//
//  HTTPRequest.swift
//  macAPIManager
//
//  Created by Angelos Staboulis on 19/2/26.
//

import Foundation
enum HTTPMethod: String, CaseIterable, Identifiable {
    case get = "GET", post = "POST", put = "PUT", patch = "PATCH", delete = "DELETE", head = "HEAD"
    var id: String { rawValue }
}

struct HTTPHeader: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var value: String
}

enum HTTPBody {
    case none
    case raw(String, contentType: String)
}

struct HTTPRequest: Identifiable {
    let id = UUID()
    var name: String = "Untitled"
    var method: HTTPMethod = .get
    var url: String = ""
    var headers: [HTTPHeader] = []
    var body: HTTPBody = .none
}

struct HTTPResponseModel {
    var statusCode: Int
    var headers: [HTTPHeader]
    var body: Data
    var duration: TimeInterval
}

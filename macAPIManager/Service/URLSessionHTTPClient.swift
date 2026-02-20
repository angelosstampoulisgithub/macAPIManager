//
//  URLSessionHTTPClient.swift
//  macAPIManager
//
//  Created by Angelos Staboulis on 19/2/26.
//

import Foundation
protocol HTTPClient {
    func send(_ request: HTTPRequest) async throws -> HTTPResponseModel
}

final class URLSessionHTTPClient: HTTPClient {
    func send(_ request: HTTPRequest) async throws -> HTTPResponseModel {
        guard let url = URL(string: request.url) else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        for header in request.headers where !header.name.isEmpty {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
        }

        switch request.body {
        case .none:
            break
        case .raw(let text, let contentType):
            let data = text.data(using: .utf8) ?? Data()
            urlRequest.httpBody = data
            if !contentType.isEmpty {
                urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }
        }

        let start = Date()
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        let duration = Date().timeIntervalSince(start)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        let headers = httpResponse.allHeaderFields.compactMap { key, value -> HTTPHeader? in
            guard let name = key as? String else { return nil }
            return HTTPHeader(name: name, value: "\(value)")
        }

        return HTTPResponseModel(
            statusCode: httpResponse.statusCode,
            headers: headers,
            body: data,
            duration: duration
        )
    }
}

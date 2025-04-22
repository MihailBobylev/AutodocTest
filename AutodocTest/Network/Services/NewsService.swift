//
//  NewsService.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import Foundation

protocol NewsServiceProtocol {
    func fetchNews(page: Int, pageSize: Int) async throws -> NewsResponse
}

final class NewsService: NewsServiceProtocol {
    private let baseURL = URL(string: NetworkConstants.shared.baseUrl)!

    func fetchNews(page: Int, pageSize: Int) async throws -> NewsResponse {
        let response: NewsResponse = try await fetch(NewsResponse.self, from: .news(page: page, pageSize: pageSize))
        return response
    }
    
    func fetch<T: Decodable>(_ type: T.Type, from endpoint: NewsEndpoint) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint.path)

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

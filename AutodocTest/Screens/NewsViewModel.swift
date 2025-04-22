//
//  MainViewModel.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import Foundation
import Combine

final class NewsViewModel: ObservableObject {
    @Published var news: [NewsItem] = []
    @Published var isLoading = false
    @Published private(set) var receivedError: (any Error)? = nil
    
    private let newsService: NewsServiceProtocol
    
    init(newsService: NewsServiceProtocol = NewsService()) {
        self.newsService = newsService
    }
    
    func loadNews() async {
        isLoading = true
        
        do {
            let newsRespone = try await newsService.fetchNews(page: 1, pageSize: 15)
            news = newsRespone.news
        } catch {
            receivedError = error
        }
        isLoading = false
    }
}

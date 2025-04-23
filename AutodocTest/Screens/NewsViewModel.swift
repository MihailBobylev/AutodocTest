//
//  MainViewModel.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import Foundation
import Combine

final class NewsViewModel: ObservableObject {
    @Published private(set) var news: [NewsItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var receivedError: (any Error)? = nil
    @Published private(set) var newsInfo: [any CollectionSectionProtocol] = []
    
    private let newsService: NewsServiceProtocol
    
    init(newsService: NewsServiceProtocol = NewsService()) {
        self.newsService = newsService
    }
    
    func loadNews() async {
        isLoading = true
        
        do {
            let newsRespone = try await newsService.fetchNews(page: 1, pageSize: 15)
            newsInfo = newsRespone.news.map { newsItem in
                CollectionSection(title: newsItem.title, type: .single, item: SingleItem(models: [.init(titleImageUrl: newsItem.titleImageUrl)]))
            }
            //news = newsRespone.news
        } catch {
            receivedError = error
        }
        isLoading = false
    }
}

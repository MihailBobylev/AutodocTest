//
//  MainViewModel.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import Foundation
import Combine

struct LoadedData {
    let newsInfo: [any GeneralSectionProtocol]
    let isPagination: Bool
}

@MainActor
final class NewsViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var receivedError: (any Error)? = nil
    
    let loadedDataSubject = PassthroughSubject<LoadedData, Never>()
    
    private(set) var pagingInfo = PagingInfo(currentPage: 1, pageSize: 15, totalCount: 0)
    private let newsService: NewsServiceProtocol
    private var loadingTask: Task<Void, Never>?
    
    init(newsService: NewsServiceProtocol = NewsService()) {
        self.newsService = newsService
    }
    
    func loadNews(reset: Bool = false) {
        guard loadingTask == nil else { return }
        
        loadingTask = Task { [weak self] in
            guard let self else { return }
            defer { loadingTask = nil }
            
            isLoading = true
            defer { isLoading = false }
            
            if reset {
                pagingInfo = PagingInfo(currentPage: 1, pageSize: pagingInfo.pageSize, totalCount: 0)
            }
            
            do {
                let response = try await newsService.fetchNews(page: pagingInfo.currentPage, pageSize: pagingInfo.pageSize)
                pagingInfo.totalCount = response.totalCount
                pagingInfo.currentPage += 1
                
                let newSections = response.news.map {
                    GeneralCollectionSection(type: .single(model: .init(newsID: $0.id,
                                                                        title: $0.title,
                                                                        description: $0.description,
                                                                        publishedDate: $0.publishedDate,
                                                                        fullUrl: $0.fullUrl,
                                                                        categoryType: $0.categoryType)),
                                             item: SingleItem(models: [.init(titleImageUrl: $0.titleImageUrl)]))
                }
                
                loadedDataSubject.send(.init(newsInfo: newSections, isPagination: !reset))
            } catch {
                print("[loadNews]: \(error)")
                receivedError = error
            }
        }
    }
    
    func loadNextPageIfNeeded() {
        guard pagingInfo.hasMore else { return }
        loadNews()
    }
}

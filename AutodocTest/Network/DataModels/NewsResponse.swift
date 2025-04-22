//
//  NewsResponse.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import Foundation

struct NewsResponse: Decodable {
    let news: [NewsItem]
    let totalCount: Int
}

struct NewsItem: Decodable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String
    let categoryType: String
}

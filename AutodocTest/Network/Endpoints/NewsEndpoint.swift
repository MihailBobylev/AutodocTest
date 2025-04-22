//
//  NewsEndpoint.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import Foundation

enum NewsEndpoint {
    case news(page: Int, pageSize: Int)

    var path: String {
        switch self {
        case .news(let page, let pageSize):
            return "api/news/\(page)/\(pageSize)"
        }
    }
}

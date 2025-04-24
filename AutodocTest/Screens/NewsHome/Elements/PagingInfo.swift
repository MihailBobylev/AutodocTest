//
//  PagingInfo.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 23.04.2025.
//

import Foundation

struct PagingInfo {
    var currentPage: Int
    let pageSize: Int
    var totalCount: Int
    
    var hasMore: Bool {
        return currentPage * pageSize < totalCount
    }
}

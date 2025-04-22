//
//  NetworkConstants.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import Foundation

struct NetworkConstants {
    
    static let shared: NetworkConstants = .init()
    
    var baseUrl: String {
        "https://webapi.autodoc.ru/"
    }
}

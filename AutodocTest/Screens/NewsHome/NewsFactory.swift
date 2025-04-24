//
//  NewsFactory.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import UIKit

struct NewsFactory {
    static func makeModule() -> UINavigationController {
        let viewModel = NewsViewModel()
        let viewController = NewsViewController(viewModel: viewModel)
        
        return .init(rootViewController: viewController)
    }
}

//
//  NewsRouter.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 24.04.2025.
//

import UIKit

enum NewsRouterIdentifiers {
    case newsDetails(fullURL: String)
}

class NewsRouter: BaseRouter {
    func route(to routeID: NewsRouterIdentifiers, from context: UIViewController) {
        switch routeID {
        case let .newsDetails(fullURL):
            let vc = NewsDetailsViewController(fullNewsURLString: fullURL)
            context.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

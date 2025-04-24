//
//  BaseRouter.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 24.04.2025.
//

import UIKit

protocol BaseRouter {
    associatedtype RouteType
    
    func route(
        to routeID: RouteType,
        from context: UIViewController
    )
}

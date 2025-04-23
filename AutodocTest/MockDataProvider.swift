//
//  MockDataProvider.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 28.03.2025.
//

import UIKit

final class DataProvider {
    static let shared = DataProvider()
    
    private var anyItemsModels: [any ItemModelProtocol] = []
    
    func addItem(_ item: any ItemModelProtocol) {
        anyItemsModels.append(item)
    }
    
    func getItem(with id: UUID) -> (any ItemModelProtocol)? {
        return anyItemsModels.first(where: { $0.id == id })
    }
    
    func clearData() {
        anyItemsModels.removeAll()
    }
}

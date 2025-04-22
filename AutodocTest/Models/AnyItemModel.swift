//
//  AnyItemModel.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 18.03.2025.
//

import Foundation

struct AnyItemModel: Identifiable, Hashable {
    let id = UUID()
    let value: any ItemModelProtocol // Храним данные любого типа
    
    init(_ value: any ItemModelProtocol, sectionID: UUID) {
        self.value = value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: AnyItemModel, rhs: AnyItemModel) -> Bool {
        return lhs.id == rhs.id
    }
}

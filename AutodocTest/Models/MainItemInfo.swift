//
//  MainItemInfo.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 30.01.2025.
//

import UIKit

// Общее
protocol GeneralSectionProtocol: Hashable {
    associatedtype Item: GeneralCollectionItemProtocol
    var id: UUID { get }
    var type: GeneralSectionType { get }
    var item: Item { get }
}

enum GeneralSectionType: Hashable {
    case single(model: SingleSectionModel)
    case loading
}

struct GeneralCollectionSection<T: GeneralCollectionItemProtocol>: Identifiable, GeneralSectionProtocol {
    let id = UUID()
    let type: GeneralSectionType
    let item: T
}

protocol GeneralItemModelProtocol: Hashable {
    var id: UUID { get }
}

protocol GeneralCollectionItemProtocol: Identifiable, Hashable {
    associatedtype Model: GeneralItemModelProtocol
    var id: UUID { get }
    var models: [Model] { get }
}

// Айтемы
struct SingleSectionModel: Hashable {
    let id = UUID()
    let newsID: Int
    let title: String?
    let description: String
    let publishedDate: String
    let fullUrl: String
    let categoryType: String
}

struct SingleItem: GeneralCollectionItemProtocol {
    let id = UUID()
    let models: [SingleItemModel]
    
    struct SingleItemModel: GeneralItemModelProtocol {
        let id = UUID()
        let titleImageUrl: String
    }
}

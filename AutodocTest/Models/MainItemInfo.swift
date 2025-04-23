//
//  MainItemInfo.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 30.01.2025.
//

import UIKit

protocol ItemModelProtocol: Hashable {
    var id: UUID { get }
}

protocol CollectionItemProtocol: Identifiable, Hashable {
    associatedtype Model: ItemModelProtocol
    var id: UUID { get }
    var models: [Model] { get }
}

struct SingleItem: CollectionItemProtocol {
    let id = UUID()
    let models: [SingleItemModel]
    
    struct SingleItemModel: ItemModelProtocol {
        let id = UUID()
        let titleImageUrl: String
    }
}

// Секции
protocol CollectionSectionProtocol: Hashable {
    associatedtype Item: CollectionItemProtocol
    var id: UUID { get }
    var title: String? { get }
    var type: SectionType { get }
    var item: Item { get }
}

struct CollectionSection<T: CollectionItemProtocol>: Identifiable, CollectionSectionProtocol {
    let id = UUID()
//    let newsID: Int
    let title: String?
//    let description: String
//    let publishedDate: String
//    let fullUrl: String
//    let categoryType: String
    let type: SectionType
    let item: T
}

struct SectionModel: Hashable {
    let id = UUID()
    let type: SectionType
    let title: String?
    //let countOfItems: Int
}

enum SectionType: Hashable {
    case single
}

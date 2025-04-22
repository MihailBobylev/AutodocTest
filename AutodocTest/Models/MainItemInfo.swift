//
//  MainItemInfo.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 30.01.2025.
//

import UIKit

protocol CollectionItemProtocol: Identifiable, Hashable {
    associatedtype Model: ItemModelProtocol
    var id: UUID { get }
    var models: [Model] { get }
}

protocol ItemModelProtocol: Identifiable, Hashable {
    var id: UUID { get }
}

struct SingleItem: CollectionItemProtocol {
    let id = UUID()
    let models: [SingleColorItem]
    
    struct SingleColorItem: ItemModelProtocol {
        let id = UUID()
        let color: UIColor
    }
}

struct CarouselItem: CollectionItemProtocol {
    let id = UUID()
    let models: [CarouselColorItem]
    
    struct CarouselColorItem: ItemModelProtocol {
        let id = UUID()
        let color: UIColor
    }
}

struct AnouncementItem: CollectionItemProtocol {
    let id = UUID()
    let models: [AnouncementModel]
    
    struct AnouncementModel: ItemModelProtocol {
        let id = UUID()
        let text: String
        let color: UIColor
    }
}

// Секции
protocol CollectionSectionProtocol: Hashable {
    associatedtype Item: CollectionItemProtocol //where Item.ID == UUID
    var id: UUID { get }
    var title: String? { get }
    var likes: Int? { get }
    var description: String? { get }
    var type: SectionType { get }
    var item: Item { get }
}

//extension CollectionSectionProtocol where Item.ID == UUID {
//    var identifier: UUID {
//        return item.id
//    }
//}

struct CollectionSection<T: CollectionItemProtocol>: Identifiable, CollectionSectionProtocol {
    let id = UUID()
    let title: String?
    let likes: Int?
    let description: String?
    let type: SectionType
    let item: T
}

struct SectionModel: Hashable {
    let id = UUID()
    let type: SectionType
    let title: String?
    let likes: Int?
    let description: String?
    let countOfItems: Int
}

enum SectionType: Hashable {
    case single
    case carousel
    case announcement
}

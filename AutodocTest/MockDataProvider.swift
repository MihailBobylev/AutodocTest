//
//  MockDataProvider.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 28.03.2025.
//

import UIKit

//final class DataProvider {
//    static let shared = DataProvider()
//
//    private var itemsBySection: [UUID: [any GeneralItemModelProtocol]] = [:]
//
//    func addItem(_ item: any GeneralItemModelProtocol, forSection sectionID: UUID) {
//        if itemsBySection[sectionID] != nil {
//            itemsBySection[sectionID]?.append(item)
//        } else {
//            itemsBySection[sectionID] = [item]
//        }
//    }
//
//    func getItem(with id: UUID) -> (any GeneralItemModelProtocol)? {
//        for (_, items) in itemsBySection {
//            if let match = items.first(where: { $0.id == id }) {
//                return match
//            }
//        }
//        return nil
//    }
//
//    func clearData() {
//        itemsBySection.removeAll()
//    }
//}

final class DataProvider {
    static let shared = DataProvider()
    
    private var sectionsIds: [any GeneralSectionProtocol] = []
    private var itemsBySection: [UUID: [any GeneralItemModelProtocol]] = [:]
    
    func addItem(_ items: [any GeneralItemModelProtocol], for section: any GeneralSectionProtocol) {
        sectionsIds.append(section)
        itemsBySection[section.id] = items
    }

    func getItem(with itemId: ItemID) -> (any GeneralItemModelProtocol)? {
        let items = itemsBySection[itemId.sectionId]
        let item = items?.first(where: { $0.id == itemId.itemId })

        return item
    }

    func getSectionForIndexPath(_ indexPath: IndexPath) -> (any GeneralSectionProtocol)? {
        sectionsIds[indexPath.section]
    }
    
    func clearData() {
        itemsBySection.removeAll()
    }
}

//
//  MockDataProvider.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 28.03.2025.
//

import UIKit

final class MockDataProvider {
    static let shared = MockDataProvider()
    
    let itemsInfo: [any CollectionSectionProtocol] = [
        CollectionSection(title: "t1", likes: 2, description: "desc1", type: .carousel, item: CarouselItem(models: [
            CarouselItem.CarouselColorItem(color: .red),
            CarouselItem.CarouselColorItem(color: .blue),
            CarouselItem.CarouselColorItem(color: .green),
            CarouselItem.CarouselColorItem(color: .yellow)
        ])),
        CollectionSection(title: "t2",
                          likes: 1,
                          description: "desc2",
                          type: .single,
                          item: SingleItem(models: [SingleItem.SingleColorItem(color: .orange)])),
        CollectionSection(title: "t3",
                          likes: 3,
                          description: "desc3",
                          type: .single,
                          item: SingleItem(models: [SingleItem.SingleColorItem(color: .cyan)])),
        CollectionSection(title: "t4", likes: 4, description: "desc4", type: .announcement, item: AnouncementItem(models: [
            AnouncementItem.AnouncementModel(text: "Announce1", color: .magenta),
            AnouncementItem.AnouncementModel(text: "Announce1", color: .blue),
            AnouncementItem.AnouncementModel(text: "Announce1", color: .green),
            AnouncementItem.AnouncementModel(text: "Announce1", color: .brown),
            AnouncementItem.AnouncementModel(text: "Announce1", color: .red)
        ])),
        CollectionSection(title: "t5", likes: 5, description: "desc5", type: .carousel, item: CarouselItem(models: [
            CarouselItem.CarouselColorItem(color: .yellow),
            CarouselItem.CarouselColorItem(color: .blue),
            CarouselItem.CarouselColorItem(color: .green),
            CarouselItem.CarouselColorItem(color: .red)
        ])),
        CollectionSection(title: "t6",
                          likes: 6,
                          description: "desc6",
                          type: .single,
                          item: SingleItem(models: [SingleItem.SingleColorItem(color: .orange)])),
        CollectionSection(title: "t1", likes: 2, description: "desc1", type: .carousel, item: CarouselItem(models: [
            CarouselItem.CarouselColorItem(color: .red),
            CarouselItem.CarouselColorItem(color: .blue),
            CarouselItem.CarouselColorItem(color: .green),
            CarouselItem.CarouselColorItem(color: .yellow)
        ])),
        CollectionSection(title: "t2",
                          likes: 1,
                          description: "desc2",
                          type: .single,
                          item: SingleItem(models: [SingleItem.SingleColorItem(color: .orange)])),
        CollectionSection(title: "t3",
                          likes: 3,
                          description: "desc3",
                          type: .single,
                          item: SingleItem(models: [SingleItem.SingleColorItem(color: .cyan)])),
        CollectionSection(title: "t4", likes: 4, description: "desc4", type: .announcement, item: AnouncementItem(models: [
            AnouncementItem.AnouncementModel(text: "Announce1", color: .magenta),
            AnouncementItem.AnouncementModel(text: "Announce1", color: .blue),
            AnouncementItem.AnouncementModel(text: "Announce1", color: .green),
            AnouncementItem.AnouncementModel(text: "Announce1", color: .brown),
            AnouncementItem.AnouncementModel(text: "Announce1", color: .red)
        ])),
        CollectionSection(title: "t5", likes: 5, description: "desc5", type: .carousel, item: CarouselItem(models: [
            CarouselItem.CarouselColorItem(color: .yellow),
            CarouselItem.CarouselColorItem(color: .blue),
            CarouselItem.CarouselColorItem(color: .green),
            CarouselItem.CarouselColorItem(color: .red)
        ])),
        CollectionSection(title: "t6",
                          likes: 6,
                          description: "desc6",
                          type: .single,
                          item: SingleItem(models: [SingleItem.SingleColorItem(color: .orange)])),
        CollectionSection(title: "t1", likes: 2, description: "desc1", type: .carousel, item: CarouselItem(models: [
            CarouselItem.CarouselColorItem(color: .red),
            CarouselItem.CarouselColorItem(color: .blue),
            CarouselItem.CarouselColorItem(color: .green),
            CarouselItem.CarouselColorItem(color: .yellow)
        ])),
        CollectionSection(title: "t2",
                          likes: 1,
                          description: "desc2",
                          type: .single,
                          item: SingleItem(models: [SingleItem.SingleColorItem(color: .orange)])),
        CollectionSection(title: "t3",
                          likes: 3,
                          description: "desc3",
                          type: .single,
                          item: SingleItem(models: [SingleItem.SingleColorItem(color: .cyan)])),
        CollectionSection(title: "t4", likes: 4, description: "desc4", type: .announcement, item: AnouncementItem(models: [
            AnouncementItem.AnouncementModel(text: "Announce1", color: .magenta),
            AnouncementItem.AnouncementModel(text: "Announce1", color: .blue),
            AnouncementItem.AnouncementModel(text: "Announce1", color: .green),
            AnouncementItem.AnouncementModel(text: "Announce1", color: .brown),
            AnouncementItem.AnouncementModel(text: "Announce1", color: .red)
        ])),
        CollectionSection(title: "t5", likes: 5, description: "desc5", type: .carousel, item: CarouselItem(models: [
            CarouselItem.CarouselColorItem(color: .yellow),
            CarouselItem.CarouselColorItem(color: .blue),
            CarouselItem.CarouselColorItem(color: .green),
            CarouselItem.CarouselColorItem(color: .red)
        ])),
        CollectionSection(title: "t6",
                          likes: 6,
                          description: "desc6",
                          type: .single,
                          item: SingleItem(models: [SingleItem.SingleColorItem(color: .orange)]))
    ]
    
    var anyItemsModels: [AnyItemModel] = []
    
    func getItem(with id: UUID) -> AnyItemModel? {
        return anyItemsModels.first(where: { $0.id == id })
    }
}

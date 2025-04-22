//
//  MainCollectionViewManager.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 30.01.2025.
//

import UIKit
import Combine

protocol MainCollectionViewManagerProtocol: UICollectionViewDelegate {
    var pagingInfoSubject: PassthroughSubject<PagingInfo, Never> { get }
    func createLayout() -> UICollectionViewCompositionalLayout
    func fillData(data: [any CollectionSectionProtocol])
}

final class MainCollectionViewManager: NSObject, MainCollectionViewManagerProtocol {
    var pagingInfoSubject = PassthroughSubject<PagingInfo, Never>()
    private var dataProvider = MockDataProvider.shared
    private var data: [any CollectionSectionProtocol] = []
    private var collectionView: UICollectionView
    private lazy var dataSource: MainDataSourse = {
        return MainDataSourse(collectionView: collectionView, manager: self, pagingInfoSubject: pagingInfoSubject, dataProvoder: dataProvider)
    }()
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self else { return nil }
            
            // Хедер
            let headerItem = makeHeader()
            
            //Футер
            let footerItem = makeFooter()
            
            let sectionType = data[sectionIndex].type
            var section: NSCollectionLayoutSection
            
            switch sectionType {
            case .single:
                //Элементы
                let group = makeSingleItemGroup()
                //Секция
                section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem, footerItem]
            case .carousel:
                //Элементы
                let group = makeCarouselItemGroup()
                //Секция
                section = NSCollectionLayoutSection(group: group)
                
                let pagerItem = makePagerItem()
                
                section.boundarySupplementaryItems = [headerItem, footerItem, pagerItem]
                section.orthogonalScrollingBehavior = .paging
                section.visibleItemsInvalidationHandler = { [weak self] (items, offset, env) -> Void in
                    guard let self else { return }
                    let pageWidth = env.container.contentSize.width
                    let currentPage = Int((offset.x / pageWidth).rounded())
                    pagingInfoSubject.send(PagingInfo(sectionIndex: sectionIndex, currentPage: currentPage))
                }
            case .announcement:
                //Элементы
                let group = makeAnnounceItemGroup()
                //Секция
                section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 8.dhs
                section.contentInsets = .init(top: 0, leading: 20.dhs, bottom: 0, trailing: 20.dhs)
            }
            
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20.dvs
        layout.configuration = config
        
        return layout
    }
    
    func fillData(data: [any CollectionSectionProtocol]) {
        self.data = data
        applySnapshot(for: dataSource)
    }
}

extension MainCollectionViewManager: FooterViewDelegate {
    func collapseDescription() {
        print("collapseDescription")
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionView.performBatchUpdates(nil)
        })
    }
}

private extension MainCollectionViewManager {
    func makeHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44.dvs)
        )
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        return headerItem
    }
    
    func makeFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80.dvs)
        )
        let footerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        footerItem.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: nil,
            top: nil,
            trailing: nil,
            bottom: .fixed(20.dvs)
        )
        
        return footerItem
    }
    
    func makeSingleItemGroup() -> NSCollectionLayoutGroup {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(400.dvs)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(400.dvs)
            ),
            subitems: [item]
        )
        return group
    }
    
    func makeCarouselItemGroup() -> NSCollectionLayoutGroup {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(400.dvs)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(400.dvs)
            ),
            subitems: [item]
        )
        return group
    }
    
    func makeAnnounceItemGroup() -> NSCollectionLayoutGroup {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(200.dhs),
                heightDimension: .absolute(120.dvs)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(200.dhs),
                heightDimension: .absolute(120.dvs)
            ),
            subitems: [item]
        )
        
        return group
    }
    
    func makePagerItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let anchor = NSCollectionLayoutAnchor(
            edges: [.bottom],
            absoluteOffset: CGPoint(x: 0, y: -30.dvs)
        )
        
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .absolute(50.dvs))
        
        let pagerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size,
                                                                    elementKind: "PagerKind",
                                                                    containerAnchor: anchor)
        
        pagerItem.zIndex = 999
        
        return pagerItem
    }
    
    func applySnapshot(for dataSource: MainDataSourse) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, AnyItemModel.ID>()

        for section in data {
            var itemsToAddIDs: [UUID] = []
            
            let resSection = SectionModel(type: section.type,
                                          title: section.title,
                                          likes: section.likes,
                                          description: section.description,
                                          countOfItems: section.item.models.count)
            
            itemsToAddIDs = section.item.models.map {
                let anyItem = AnyItemModel($0, sectionID: section.id)
                dataProvider.anyItemsModels.append(anyItem)
                return anyItem.id
            }
            
            snapshot.appendSections([resSection])
            snapshot.appendItems(itemsToAddIDs, toSection: resSection)
        }

        DispatchQueue.main.async {
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

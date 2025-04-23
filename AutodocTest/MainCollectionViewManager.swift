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

//protocol MainCollectionViewManagerDelegate: AnyObject {
//    func didSelectNews(info: NotificationInfo)
//    func makePaginationSkeleton()
//}

final class MainCollectionViewManager: NSObject, MainCollectionViewManagerProtocol {
    var pagingInfoSubject = PassthroughSubject<PagingInfo, Never>()
    private var dataProvider = MockDataProvider.shared
    private var data: [any CollectionSectionProtocol] = []
    private var collectionView: UICollectionView
    private lazy var dataSource: MainDataSourse = {
        return MainDataSourse(collectionView: collectionView, dataProvoder: dataProvider)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? SingleCollectionCell)?.cancelImageLoading()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row].item
        
    }
}

//extension MainCollectionViewManager: FooterViewDelegate {
//    func collapseDescription() {
//        print("collapseDescription")
//        UIView.animate(withDuration: 0.3, animations: {
//            self.collectionView.performBatchUpdates(nil)
//        })
//    }
//}

private extension MainCollectionViewManager {
    func makeHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60.dvs)
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
        let aspectRatio: CGFloat = 1067.0 / 1600.0
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(aspectRatio) // <– ключевой момент
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(aspectRatio)
            ),
            subitems: [item]
        )
        
        return group
    }
    
//    func makePagerItem() -> NSCollectionLayoutBoundarySupplementaryItem {
//        let anchor = NSCollectionLayoutAnchor(
//            edges: [.bottom],
//            absoluteOffset: CGPoint(x: 0, y: -30.dvs)
//        )
//        
//        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                          heightDimension: .absolute(50.dvs))
//        
//        let pagerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size,
//                                                                    elementKind: "PagerKind",
//                                                                    containerAnchor: anchor)
//        
//        pagerItem.zIndex = 999
//        
//        return pagerItem
//    }
    
    func applySnapshot(for dataSource: MainDataSourse) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, AnyItemModel.ID>()
        dataProvider.clearData()
        
        for section in data {
            var itemsToAddIDs: [UUID] = []
            
            let resSection = SectionModel(type: section.type,
                                          title: section.title)
            
            itemsToAddIDs = section.item.models.map {
                let anyItem = AnyItemModel($0, sectionID: section.id)
                dataProvider.addItem(anyItem)
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

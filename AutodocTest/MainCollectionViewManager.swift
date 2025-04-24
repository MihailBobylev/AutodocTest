//
//  MainCollectionViewManager.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 30.01.2025.
//

import UIKit
import Combine

protocol MainCollectionViewManagerProtocol: UICollectionViewDelegate {
    var getNextPageSubject: PassthroughSubject<Void, Never> { get }
    var openNewsDetailsFromUrl: PassthroughSubject<String, Never> { get }
    func createLayout() -> UICollectionViewCompositionalLayout
    func fillData(loadedData: LoadedData)
}

final class MainCollectionViewManager: NSObject, MainCollectionViewManagerProtocol {
    private var dataProvider = DataProvider.shared
    private var data: [any CollectionSectionProtocol] = []
    private var collectionView: UICollectionView
    private lazy var dataSource: MainDataSourse = {
        return MainDataSourse(collectionView: collectionView, dataProvoder: dataProvider)
    }()
    
    let getNextPageSubject = PassthroughSubject<Void, Never>()
    let openNewsDetailsFromUrl = PassthroughSubject<String, Never>()
    
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
    
    func fillData(loadedData: LoadedData) {
        if loadedData.isPagination {
            self.data += loadedData.newsInfo
        } else {
            self.data = loadedData.newsInfo
        }
        
        applySnapshot(for: dataSource, loadedNewsItems: loadedData.newsInfo, isPagination: loadedData.isPagination)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? SingleCollectionCell)?.startImageLoading()
        
        if indexPath.section == data.count - 1 {
            getNextPageSubject.send()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //(cell as? SingleCollectionCell)?.cancelImageLoading()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = data[indexPath.section]
        switch selectedItem.type {
        case .single:
            if let selectedItem = selectedItem as? CollectionSection<SingleItem> {
                openNewsDetailsFromUrl.send(selectedItem.fullUrl)
            }
        }
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
                heightDimension: .fractionalWidth(aspectRatio)
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
    
    func applySnapshot(for dataSource: MainDataSourse, loadedNewsItems: [any CollectionSectionProtocol], isPagination: Bool) {
        var snapshot = dataSource.snapshot()
        if !isPagination {
            dataProvider.clearData()
        }
        
        for section in loadedNewsItems {
            let resSection = SectionModel(type: section.type, title: section.title, categoryType: "")
            let itemIDs = section.item.models.map { model in
                dataProvider.addItem(model)
                return model.id
            }
            
            snapshot.appendSections([resSection])
            snapshot.appendItems(itemIDs, toSection: resSection)
        }

        DispatchQueue.main.async {
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

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
    func resetAllData()
    func setLoading(_ isLoading: Bool)
}

final class MainCollectionViewManager: NSObject, MainCollectionViewManagerProtocol {
    private var dataProvider = DataProvider.shared
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
            
            let sectionType = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            var section: NSCollectionLayoutSection
            
            switch sectionType {
            case .single:
                let headerItem = makeHeader()
                let footerItem = makeFooter()
                
                section = makeSingleItemSection()
                section.boundarySupplementaryItems = [headerItem, footerItem]
            case .loading:
                section = makeLoaderItemSection()
            }
            
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20.dvs
        layout.configuration = config
        
        return layout
    }
    
    func fillData(loadedData: LoadedData) {
        applySnapshot(for: dataSource, loadedNewsItems: loadedData.newsInfo)
    }
    
    func resetAllData() {
        dataProvider.clearData()
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setLoading(_ isLoading: Bool) {
        var snapshot = dataSource.snapshot()
        
        if isLoading {
            guard !snapshot.sectionIdentifiers.contains(.loading) else { return }
            let loadingItem = ItemID(sectionId: LoaderCollectionCell.sectionId, itemId: LoaderCollectionCell.id)
            snapshot.appendSections([.loading])
            snapshot.appendItems([loadingItem], toSection: .loading)
        } else {
            if snapshot.sectionIdentifiers.contains(.loading) {
                snapshot.deleteSections([.loading])
            }
        }
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension MainCollectionViewManager {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? SingleCollectionCell)?.startImageLoading()
        
        if indexPath.section == dataProvider.sectionsIds.count - 1 {
            getNextPageSubject.send()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = dataProvider.getSectionForIndexPath(indexPath) else { return }
        
        switch selectedItem.type {
        case let .single(model):
            openNewsDetailsFromUrl.send(model.fullUrl)
        case .loading:
            break
        }
    }
}

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
            heightDimension: .absolute(60.dvs)
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
    
    func makeSingleItemSection() -> NSCollectionLayoutSection {
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
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func makeLoaderItemSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(20.dvs)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8.dvs, leading: 0, bottom: 8.dvs, trailing: 0)
        
        return section
    }
    
    func applySnapshot(for dataSource: MainDataSourse, loadedNewsItems: [any GeneralSectionProtocol]) {
        var snapshot = dataSource.snapshot()
        
        for section in loadedNewsItems {
            let models = section.item.models
            let itemIDs = models.map { model in
                return ItemID(sectionId: section.id, itemId: model.id)
            }
            dataProvider.addItem(models, for: section)
            
            snapshot.appendSections([section.type])
            snapshot.appendItems(itemIDs, toSection: section.type)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

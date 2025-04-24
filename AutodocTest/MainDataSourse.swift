//
//  MainDataSourse.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 30.01.2025.
//

import UIKit
import Combine

final class MainDataSourse: UICollectionViewDiffableDataSource<GeneralSectionType, UUID> {
    init(collectionView: UICollectionView,
         dataProvoder: DataProvider) {
        super.init(collectionView: collectionView) { collectionView, indexPath, itemModelID in
            let item = dataProvoder.getItem(with: itemModelID)
            
            if let singleItem = item as? SingleItem.SingleItemModel {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleCollectionCell.reuseID, for: indexPath) as?
                        SingleCollectionCell else { return UICollectionViewCell() }
                cell.configure(itemModel: singleItem)
                return cell
            }
            
            return nil
        }
        
        self.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let section = self.sectionIdentifier(for: indexPath.section) else { return UICollectionReusableView() }
            if kind == UICollectionView.elementKindSectionHeader {
                switch section {
                case let .single(model):
                    guard let header = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: HeaderView.reuseID,
                        for: indexPath
                    ) as? HeaderView else { return UICollectionReusableView() }
                    
                    header.configure(with: model.title)
                    return header
                }
            }
            
            if kind == UICollectionView.elementKindSectionFooter {
                switch section {
                case let .single(model):
                    guard let footer = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: FooterView.reuseID,
                        for: indexPath
                    ) as? FooterView else { return UICollectionReusableView() }
                    
                    footer.configure(with: model.categoryType)
                    return footer
                }
            }
            
//            if kind == "PagerKind" {
//                switch section.type {
//                case .announcement, .single:
//                    return nil
//                case .carousel:
//                    guard let pagerView = collectionView.dequeueReusableSupplementaryView(
//                        ofKind: kind,
//                        withReuseIdentifier: PagerView.reuseID,
//                        for: indexPath
//                    ) as? PagerView else { return UICollectionReusableView() }
//                    
//                    pagerView.configure(numberOfPages: section.countOfItems)
//                    pagerView.subscribeTo(subject: pagingInfoSubject, for: indexPath.section)
//                    return pagerView
//                }
//            }
            
            return nil
        }
    }
}

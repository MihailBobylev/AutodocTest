//
//  MainCollectionCell.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 30.01.2025.
//

import UIKit
import SnapKit

final class SingleCollectionCell: UICollectionViewCell {
    
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    private var itemModel: SingleItem.SingleColorItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = nil
    }
}

extension SingleCollectionCell {
    func configure(itemModel: SingleItem.SingleColorItem) {
        self.itemModel = itemModel
        contentView.backgroundColor = itemModel.color
    }
}

private extension SingleCollectionCell {
    func setupUI() {
        
    }
}


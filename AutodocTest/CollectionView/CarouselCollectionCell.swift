//
//  CarouselCollectionCell.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 04.02.2025.
//

import UIKit
import SnapKit

final class CarouselCollectionCell: UICollectionViewCell {
    
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    private var itemModel: CarouselItem.CarouselColorItem?
    
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

extension CarouselCollectionCell {
    func configure(itemModel: CarouselItem.CarouselColorItem) {
        self.itemModel = itemModel
        contentView.backgroundColor = itemModel.color
    }
}

private extension CarouselCollectionCell {
    func setupUI() {
        
    }
}

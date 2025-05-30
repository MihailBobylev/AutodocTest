//
//  MainCollectionCell.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 30.01.2025.
//

import UIKit
import SnapKit

final class SingleCollectionCell: UICollectionViewCell {
    private let imageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    private var itemModel: SingleItem.SingleItemModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelImageLoad()
        imageView.image = nil
    }
}

extension SingleCollectionCell {
    func configure(itemModel: SingleItem.SingleItemModel) {
        self.itemModel = itemModel
        startImageLoading()
    }
    
    func startImageLoading() {
        guard let titleImageUrl = itemModel?.titleImageUrl else { return }
        guard imageView.image == nil else { return }
        
        if let url = URL(string: titleImageUrl) {
            let targetSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height)
            imageView.loadImage(from: url, targetSize: targetSize)
        }
    }
    
    func cancelImageLoading() {
        imageView.cancelImageLoad()
    }
}

private extension SingleCollectionCell {
    func setupUI() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//
//  MainCollectionCell.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 30.01.2025.
//

import UIKit
import SnapKit

final class SingleCollectionCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        ImageLoader.shared.cancelLoad(for: imageView)
    }
    
    func configure(titleImageUrl: String?) {
        guard let url = URL(string: titleImageUrl ?? "") else {
            print("SingleCollectionCell: invalid url")
            imageView.image = UIImage(resource: .imageNotFound)
            return
        }
        let targetSize = contentView.bounds.size
        ImageLoader.shared.loadImage(from: url, into: imageView, targetSize: targetSize)
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

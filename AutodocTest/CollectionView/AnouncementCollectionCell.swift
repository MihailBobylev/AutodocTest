//
//  AnouncementCollectionCell.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 03.02.2025.
//

import UIKit
import SnapKit

final class AnouncementCollectionCell: UICollectionViewCell {
    
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var itemModel: AnouncementItem.AnouncementModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnouncementCollectionCell {
    func configure(itemModel: AnouncementItem.AnouncementModel) {
        self.itemModel = itemModel
        textLabel.text = itemModel.text
        contentView.backgroundColor = itemModel.color
    }
}

private extension AnouncementCollectionCell {
    func setupUI() {
        contentView.layer.cornerRadius = 8.dhs
        contentView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

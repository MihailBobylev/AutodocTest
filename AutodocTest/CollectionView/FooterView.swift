//
//  FooterView.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 31.01.2025.
//

import UIKit
import SnapKit

protocol FooterViewDelegate: AnyObject {
    func collapseDescription()
}

final class FooterView: UICollectionReusableView {
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    private let categoryTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18.dfs)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with categoryType: String) {
        categoryTypeLabel.text = categoryType
    }
}

private extension FooterView {
    func setupUI() {
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        backgroundColor = .cyan
        addSubview(categoryTypeLabel)
        
        categoryTypeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8.dvs)
            make.leading.trailing.equalToSuperview().inset(16.dhs)
        }
    }
}

//
//  HeaderView.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 31.01.2025.
//

import UIKit
import SnapKit

final class HeaderView: UICollectionReusableView {
    static var reuseID: String {
        String(describing: Self.self)
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
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

    func configure(with title: String?) {
        titleLabel.text = title
    }
}

private extension HeaderView {
    func setupUI() {
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        backgroundColor = .lightGray
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8.dhs)
        }
    }
}

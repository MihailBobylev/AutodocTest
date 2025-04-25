//
//  LoaderCollectionCell.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 24.04.2025.
//

import UIKit
import SnapKit

final class LoaderCollectionCell: UICollectionViewCell {
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    static let sectionId: UUID = {
        guard let uuid = UUID(uuidString: "00000000-0000-0000-0000-000000000002") else {
            fatalError("Failed to initialize UUID for LoaderCollectionCell")
        }
        return uuid
    }()
    
    static let id: UUID = {
        guard let uuid = UUID(uuidString: "00000000-0000-0000-0000-000000000001") else {
            fatalError("Failed to initialize UUID for LoaderCollectionCell")
        }
        return uuid
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.startAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LoaderCollectionCell {
    func setupUI() {
        contentView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        activityIndicator.startAnimating()
    }
}

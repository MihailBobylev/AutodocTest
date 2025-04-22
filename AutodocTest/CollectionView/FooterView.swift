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

    private lazy var mainHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8.dhs
        return stack
    }()
    
    private lazy var likeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private lazy var shareImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "arrow.right"))
        imageView.tintColor = .systemBlue
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(collapseDescription))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18.dfs)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    private lazy var descriptionContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18.dfs)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 8
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    weak var delegate: FooterViewDelegate?
    private var descriptionLabelHeightConstraint: Constraint?
    private var originalHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with countOfLikes: Int?, description: String?) {
        countLabel.text = String(countOfLikes ?? 0)
        descriptionLabel.text = description
        
        originalHeight = descriptionLabel.intrinsicContentSize.height
    }
    
    var myToggle: Bool = false
    @objc func collapseDescription() {
        myToggle.toggle()
        let targetHeight = myToggle ? 172.dvs : 24.dvs

        UIView.animate(withDuration: 0.3, animations: {
            self.descriptionLabelHeightConstraint?.update(offset: targetHeight)
            self.layoutIfNeeded()
        })
        delegate?.collapseDescription()
    }
}

private extension FooterView {
    func setupUI() {
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        backgroundColor = .cyan
        addSubview(mainHStack)
        mainHStack.addArrangedSubview(likeImageView)
        mainHStack.addArrangedSubview(countLabel)
        mainHStack.addArrangedSubview(UIView())
        mainHStack.addArrangedSubview(shareImageView)
        addSubview(descriptionContainer)
        descriptionContainer.addSubview(descriptionLabel)
        
        mainHStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8.dhs)
        }
        
        likeImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24.dhs)
        }
        
        shareImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24.dhs)
        }
        
        descriptionContainer.snp.makeConstraints { make in
            make.top.equalTo(mainHStack.snp.bottom).offset(8.dvs)
            make.leading.trailing.equalToSuperview().inset(8.dhs)
            //descriptionLabelHeightConstraint = make.height.equalTo(24.dvs).constraint
            make.bottom.equalToSuperview().inset(8.dvs)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
}

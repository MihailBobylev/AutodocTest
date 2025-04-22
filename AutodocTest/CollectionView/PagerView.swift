//
//  PagerView.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 31.01.2025.
//

import UIKit
import SnapKit
import Combine

final class PagerView: UICollectionReusableView {
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .black
        control.isUserInteractionEnabled = false
        return control
    }()
    
    private var pagingInfoToken: AnyCancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pagingInfoToken?.cancel()
        pagingInfoToken = nil
    }
    
    func configure(numberOfPages: Int, currentPage: Int = 0) {
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
    }
    
    func updateCurrentPage(to page: Int) {
        pageControl.currentPage = page
    }
    
    func subscribeTo(subject: PassthroughSubject<PagingInfo, Never>, for section: Int) {
        pagingInfoToken = subject
            .filter { $0.sectionIndex == section }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pagingInfo in
                self?.pageControl.currentPage = pagingInfo.currentPage
            }
    }
}

private extension PagerView {
    func setupViews() {
        addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

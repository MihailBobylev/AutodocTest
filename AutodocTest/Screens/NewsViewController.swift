//
//  ViewController.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 30.01.2025.
//

import UIKit
import SnapKit
import Combine

final class NewsViewController: UIViewController {
    private let mainCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(SingleCollectionCell.self, forCellWithReuseIdentifier: SingleCollectionCell.reuseID)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseID)
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.reuseID)
        //collectionView.register(PagerView.self, forSupplementaryViewOfKind: "PagerKind", withReuseIdentifier: PagerView.reuseID)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    private let refreshControl = UIRefreshControl()
    
    private let viewModel: NewsViewModel
    private var notificationsCollectionViewManager: MainCollectionViewManagerProtocol?
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        bind()
        setupUI()
        
        Task {
            await viewModel.loadNews()
        }
    }
}

private extension NewsViewController {
    @objc func refresh(sender: UIRefreshControl) {
        Task {
            await viewModel.loadNews()
        }
        sender.endRefreshing()
    }
    
    func setupAppearance() {
        notificationsCollectionViewManager = MainCollectionViewManager(collectionView: mainCollectionView)
        guard let notificationsCollectionViewManager else { return }
        let layout = notificationsCollectionViewManager.createLayout()
        mainCollectionView.setCollectionViewLayout(layout, animated: false)
        mainCollectionView.delegate = notificationsCollectionViewManager
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        mainCollectionView.refreshControl = refreshControl
    }
    
    func bind() {
        viewModel.$newsInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] news in
                guard let self else { return }
                notificationsCollectionViewManager?.fillData(data: news)
            }.store(in: &cancellables)
        
        viewModel.$receivedError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error else { return }
                self?.showToast(error: error)
            }.store(in: &cancellables)
    }
    
    func setupUI() {
        view.addSubview(mainCollectionView)
        
        mainCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

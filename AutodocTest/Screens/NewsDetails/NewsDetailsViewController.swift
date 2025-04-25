//
//  NewsDetailsViewController.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 24.04.2025.
//

import Foundation
import SnapKit
import WebKit

final class NewsDetailsViewController: UIViewController {
    
    private let fullNewsURLString: String
    private let webView = WKWebView()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(fullNewsURLString: String) {
        self.fullNewsURLString = fullNewsURLString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func loadPage() {
        guard let url = URL(string: fullNewsURLString) else {
            showToast(message: "Некорректная ссылка.")
            return
        }
        activityIndicator.startAnimating()
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension NewsDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}

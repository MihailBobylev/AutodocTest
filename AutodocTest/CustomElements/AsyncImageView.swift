//
//  AsyncImageView.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import UIKit

final class AsyncImageView: UIImageView {
    private var currentLoadingURL: URL?

    func loadImage(from url: URL, targetSize: CGSize) {
        self.currentLoadingURL = url
        self.image = nil
        ImageLoaderQueue.shared.load(url: url, targetSize: targetSize, into: self, expectedURL: url)
    }

    func cancelImageLoad() {
        guard let currentLoadingURL else { return }
        ImageLoaderQueue.shared.cancel(url: currentLoadingURL)
    }
}

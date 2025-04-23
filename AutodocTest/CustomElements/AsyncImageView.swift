//
//  AsyncImageView.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import UIKit

final class AsyncImageView: UIImageView {
    private var url: URL?

    func loadImage(from url: URL, targetSize: CGSize) {
        self.url = url
        self.image = nil
        ImageLoaderQueue.shared.load(url: url, targetSize: targetSize, into: self)
    }

    func cancelImageLoad() {
        guard let url else { return }
        ImageLoaderQueue.shared.cancel(url: url)
    }
}

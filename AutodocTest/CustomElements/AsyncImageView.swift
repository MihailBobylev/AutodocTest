//
//  AsyncImageView.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import UIKit

final class AsyncImageView: UIImageView {
    
    private var imageLoadTask: Task<Void, Never>?
    
    func loadImage(from url: URL) {
        let key = url.absoluteString

        self.image = nil
        
        if let cachedImage = ImageCache.shared.image(forKey: key) {
            self.image = cachedImage
            return
        }
        
        imageLoadTask = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled else { return }
                
                if let image = UIImage(data: data) {
                    ImageCache.shared.set(image, forKey: key)
                    await MainActor.run {
                        self.image = image
                    }
                } else {
                    print("Не удалось преобразовать изображение")
                }
            } catch {
                print("Не удалось загрузить изображение:", error)
            }
        }
    }
    
    func cancelImageLoad() {
        imageLoadTask?.cancel()
        imageLoadTask = nil
    }
}

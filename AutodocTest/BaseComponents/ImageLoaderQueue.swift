//
//  ImageLoaderQueue.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 23.04.2025.
//

import Foundation
import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    
    private let semaphore = AsyncSemaphore(count: 4)
    private let cache = NSCache<NSString, UIImage>()
    private let taskMap = NSMapTable<UIImageView, TaskBox>(
        keyOptions: .weakMemory,
        valueOptions: .strongMemory
    )
    
    private init() {}
    
    func loadImage(from url: URL, into imageView: UIImageView, targetSize: CGSize) {
        cancelLoad(for: imageView)
        imageView.image = nil
        
        let cacheKey = url.absoluteString as NSString
        if let cached = cache.object(forKey: cacheKey) {
            imageView.image = cached
            return
        }
        
        let task = Task.detached { [weak self, weak imageView] in
            await self?.semaphore.wait()
            defer { Task { await self?.semaphore.signal() } }
            
            guard let data = try? Data(contentsOf: url),
                  let originalImage = UIImage(data: data) else { return }
            
            let resized = await self?.resize(image: originalImage, targetSize: targetSize)
            let imageView = imageView
            await MainActor.run {
                guard let imageView = imageView else { return }
                if imageView.associatedURL == url {
                    imageView.image = resized
                }
            }
            
            if let resized, let self {
                self.cache.setObject(resized, forKey: cacheKey)
            }
        }
        
        taskMap.setObject(TaskBox(task), forKey: imageView)
        imageView.associatedURL = url
    }
    
    func cancelLoad(for imageView: UIImageView) {
        taskMap.object(forKey: imageView)?.task.cancel()
        taskMap.removeObject(forKey: imageView)
    }
}

private extension ImageLoader {
    func resize(image: UIImage, targetSize: CGSize) async -> UIImage {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let renderer = UIGraphicsImageRenderer(size: targetSize)
                let resized = renderer.image { _ in
                    image.draw(in: CGRect(origin: .zero, size: targetSize))
                }
                continuation.resume(returning: resized)
            }
        }
    }
}

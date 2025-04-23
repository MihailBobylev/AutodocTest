//
//  ImageLoaderQueue.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 23.04.2025.
//

import Foundation
import UIKit

final class ImageLoaderQueue {
    static let shared = ImageLoaderQueue()

    private let loadingSemaphore = AsyncSemaphore(count: 4)
    private var loadingTasks: [URL: Task<Void, Never>] = [:]
    private let accessQueue = DispatchQueue(label: "image.loader.task.access")

    private init() {}

    func load(url: URL, targetSize: CGSize, into imageView: UIImageView) {
        let key = url.absoluteString

        if let cached = ImageCache.shared.image(forKey: key) {
            imageView.image = cached
            return
        }

        cancel(url: url)

        let task = Task {
            await loadingSemaphore.wait()
            defer {
                Task {
                    await loadingSemaphore.signal()
                }
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled else { return }

                if let image = UIImage(data: data) {
                    let resized = ImageCache.shared.resizedImage(image, targetSize: targetSize)
                    ImageCache.shared.set(resized, forKey: key)

                    await MainActor.run {
                        imageView.image = resized
                    }
                } else {
                    print("Ошибка преобразования изображения")
                }
            } catch {
                print("Ошибка загрузки изображения:", error)
            }
        }

        accessQueue.async {
            self.loadingTasks[url] = task
        }
    }

    func cancel(url: URL) {
        accessQueue.async {
            self.loadingTasks[url]?.cancel()
            self.loadingTasks.removeValue(forKey: url)
        }
    }
}

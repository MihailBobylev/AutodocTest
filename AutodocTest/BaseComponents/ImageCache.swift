//
//  ImageCache.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private init() {}

    private let cache = NSCache<NSString, UIImage>()

    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
//    func resizedImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//        return renderer.image { _ in
//            image.draw(in: CGRect(origin: .zero, size: targetSize))
//        }
//    }
    
    func resizedImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let ciImage = CIImage(image: image)
        let scale = targetSize.width / image.size.width
        let transform = CGAffineTransform(scaleX: scale, y: scale)

        guard let resizedCIImage = ciImage?.transformed(by: transform) else {
            return nil
        }

        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(resizedCIImage, from: resizedCIImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}

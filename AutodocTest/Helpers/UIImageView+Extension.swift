//
//  UIImageView+Extension.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import UIKit

//extension UIImageView {
//    private static var taskKey: UInt8 = 0
//    
//    private var imageLoadTask: Task<Void, Never>? {
//        get {
//            objc_getAssociatedObject(self, &Self.taskKey) as? Task<Void, Never>
//        }
//        set {
//            objc_setAssociatedObject(self, &Self.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//    
//    func loadImage(from url: URL, identifier: String) {
//        imageLoadTask?.cancel()
//        self.image = nil
//        
//        if let cachedImage = ImageCache.shared.image(forKey: identifier) {
//            self.image = cachedImage
//            return
//        }
//        
//        imageLoadTask = Task {
//            do {
//                let (data, _) = try await URLSession.shared.data(from: url)
//                guard !Task.isCancelled else { return }
//                
//                if let image = UIImage(data: data) {
//                    ImageCache.shared.set(image, forKey: identifier)
//                    await MainActor.run {
//                        self.image = image
//                    }
//                } else {
//                    print("Не удалось преобразовать изображение")
//                }
//            } catch {
//                print("Не удалось загрузить изображение:", error)
//            }
//        }
//    }
//    
//    func cancelImageLoad() {
//        imageLoadTask?.cancel()
//        imageLoadTask = nil
//    }
//}

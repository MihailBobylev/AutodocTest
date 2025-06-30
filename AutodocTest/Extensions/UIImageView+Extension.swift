//
//  UIImageView+Extension.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import UIKit

private var urlKey: UInt8 = 0

extension UIImageView {
    var associatedURL: URL? {
        get { objc_getAssociatedObject(self, &urlKey) as? URL }
        set { objc_setAssociatedObject(self, &urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

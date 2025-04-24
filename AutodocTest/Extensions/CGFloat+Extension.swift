//
//  CGFloat+Extension.swift
//  QRme_test2
//
//  Created by Михаил Бобылев on 30.01.2025.
//

import UIKit

fileprivate let baseDeviceHeight: CGFloat = 818
fileprivate let baseDeviceWidth: CGFloat = 375

extension CGFloat {
    
    var dfs: CGFloat {
        return CGFloat.getDynamicFontSize(size: self)
    }
    
    var dvs: CGFloat {
        return CGFloat.getDynamicVerticalSize(size: self)
    }
    
    var dhs: CGFloat {
        return CGFloat.getDynamicHorizontalSize(size: self)
    }
    
    func projectedOffset(decelerationRate: UIScrollView.DecelerationRate) -> CGFloat {
        let multiplier = 1 / (1 - decelerationRate.rawValue) / 1_000
        return self * multiplier
    }
    
    // Minimum visible font size is 10
    fileprivate static func getDynamicFontSize(size: CGFloat) -> CGFloat {
        return (CGFloat.maximum(10, size * UIScreen.main.bounds.height / baseDeviceHeight))
    }
    
    fileprivate static func getDynamicVerticalSize(size: CGFloat) -> CGFloat {
        return (size * UIScreen.main.bounds.height / baseDeviceHeight)
    }
    
    fileprivate static func getDynamicHorizontalSize(size: CGFloat) -> CGFloat {
        return (size * UIScreen.main.bounds.width / baseDeviceWidth)
    }
    
    func rounded(toPlaces places: Int) -> CGFloat {
        let multiplier = pow(10.0, CGFloat(places))
        return (self * multiplier).rounded() / multiplier
    }
}

extension Int {
    
    var dfs: CGFloat {
        return CGFloat.getDynamicFontSize(size: CGFloat(self))
    }
    
    var dvs: CGFloat {
        return CGFloat.getDynamicVerticalSize(size: CGFloat(self))
    }
    
    var dhs: CGFloat {
        return CGFloat.getDynamicHorizontalSize(size: CGFloat(self))
    }
}

extension Double {
    
    var dfs: CGFloat {
        return CGFloat.getDynamicFontSize(size: CGFloat(self))
    }
    
    var dvs: CGFloat {
        return CGFloat.getDynamicVerticalSize(size: CGFloat(self))
    }
    
    var dhs: CGFloat {
        return CGFloat.getDynamicHorizontalSize(size: CGFloat(self))
    }
}


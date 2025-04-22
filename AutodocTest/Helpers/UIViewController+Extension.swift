//
//  UIViewController+Extension.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 22.04.2025.
//

import UIKit

extension UIViewController {
    func showToast(error: any Error, interval: Double = 3) {
        let message = (error as (any CustomStringConvertible)).description
        showToast(message: message, interval: interval)
    }
    
    func showToast(message: String, interval: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.view.backgroundColor = .accentColor
        alert.view.alpha = 1
        alert.view.layer.cornerRadius = 15
        
        let cancelAction = UIAlertAction(title: "Ок", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

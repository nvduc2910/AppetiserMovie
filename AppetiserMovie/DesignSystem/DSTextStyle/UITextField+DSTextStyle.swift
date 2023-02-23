//
//  UITextField+DSTextStyle.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UITextField {
    
    public func setStyle(_ style: DSTextStyle) {
        font = style.font
        textColor = style.color
    }
    
    var clearButton: UIButton? {
        return value(forKey: "clearButton") as? UIButton
    }

    var clearButtonTintColor: UIColor? {
        get {
            return clearButton?.tintColor
        }
        set {
            _ = rx.observe(UIImage.self, "clearButton.imageView.image")
                .take(until: rx.deallocating)
                .subscribe(onNext: { [weak self] _ in
                    let image = self?.clearButton?.imageView?.image?.withRenderingMode(.alwaysTemplate)
                    self?.clearButton?.setImage(image, for: .normal)
                })
            clearButton?.tintColor = newValue
        }
    }
}

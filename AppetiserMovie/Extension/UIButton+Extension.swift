//
//  UIButton+Extension.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//

import Foundation
import UIKit

extension UIButton {
    
    func setCornerRadius(radius: CGFloat, borderColor: UIColor? = nil, borderWidth: CGFloat = 0) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
    }
}

//
//  UIButton+DSTextStyle.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//


import UIKit

extension UIButton {
    
    public func setStyle(_ style: DSTextStyle) {
        titleLabel?.font = style.font
        setTitleColor(style.color, for: .normal)
    }
    
    public func setText(_ title: String?, for state: UIControl.State = .normal) {
        setTitle(title, for: state)
    }
}

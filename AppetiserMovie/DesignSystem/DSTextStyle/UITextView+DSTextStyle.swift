//
//  UITextView+DSTextStyle.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//


import UIKit

extension UITextView {
    
    public func setStyle(_ style: DSTextStyle) {
        font = style.font
        textColor = style.color
    }
}


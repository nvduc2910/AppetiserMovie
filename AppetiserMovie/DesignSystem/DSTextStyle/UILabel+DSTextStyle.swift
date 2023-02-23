//
//  UILabel+TextStyle.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//


import Foundation
import UIKit

extension UILabel {
    
    public func setStyle(_ style: DSTextStyle) {
        self.font = style.font
        self.textColor = style.color
    }
    
    func setLineHeight(lineHeight: CGFloat)
    {
        let text = self.text
        if let text = text
        {

            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()

           style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                        value: style,
                                         range: NSMakeRange(0, text.count))

           self.attributedText = attributeString
        }
    }
}

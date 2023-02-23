//
//  DSButton.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//

import Foundation
import UIKit

extension UIButton {
    
    func setPlainStyle(title: String,
                       textColor: UIColor = Colors.primary,
                       borderColor: UIColor = Colors.primary,
                       borderWidth: CFloat = 1,
                       cornerRadius: CFloat = 8, fontSize: CGFloat = 17) {
        
        setStyle(DS.NovaSemiBold(color: textColor, fontSize: fontSize))
        setCornerRadius(radius: CGFloat(cornerRadius),
                             borderColor: borderColor,
                             borderWidth: CGFloat(borderWidth))
        
        self.backgroundColor = .clear
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
    }
    
    func setPrimaryStyle(title: String,
                         borderColor: UIColor = .clear,
                         borderWidth: CFloat = 0.0,
                         cornerRadius: CFloat = 8.0,
                         fontSize: CGFloat = 17) {
        
        setStyle(DS.NovaSemiBold(color: .white, fontSize: fontSize))
        setCornerRadius(radius: CGFloat(cornerRadius),
                             borderColor: borderColor,
                             borderWidth: CGFloat(borderWidth))
        backgroundColor = Colors.primary
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
    }
}

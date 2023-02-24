//
//  DSColor.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//

import Foundation
import UIKit

public enum Colors {
    
    // MARK: - primary colors
    
    static var primary: UIColor {
        return Colors.hex(hex: "#15141F")
    }
    
    static var secondary: UIColor {
        return Colors.hex(hex: "#201F2C")
    }
    
    static var highLight: UIColor {
        return Colors.hex(hex: "#EB5757")
    }
    
    static var neutral200: UIColor {
        return Colors.hex(hex: "#786C86")
    }
    
    static var neutral: UIColor {
        return Colors.hex(hex: "#CCCACA")
    }
    
    static var neutral100: UIColor {
        return Colors.hex(hex: "#B6B6B6")
    }
    
    static var white: UIColor {
        return Colors.hex(hex: "#FFFFFF")
    }
    
    static var white230: UIColor {
        return Colors.hex(hex: "#E9E6E6")
    }
}

public extension Colors {
    
    static func hex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
    
    static func RGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat(red / 255),
                       green: CGFloat(green / 255),
                       blue: CGFloat(blue / 255),
                       alpha: alpha)
    }
    
    static func RGBPoint(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat(red),
                       green: CGFloat(green),
                       blue: CGFloat(blue),
                       alpha: alpha)
    }
    
    enum GradientType: Int {
        case topToBottom
        case bottomToTop
        case topLeftToBottomRight
        case bottomLeftToTopRight
    }
    
    static func makeGradientLayer(size: CGSize,
                                  from: UIColor,
                                  to color: UIColor,
                                  type: GradientType) -> CAGradientLayer {
        let colors = [from.cgColor, color.cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "GradientBackground"
        switch type {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        case .topLeftToBottomRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        case .bottomLeftToTopRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = colors
        return gradientLayer
    }
    
    static func colorAlpha(_ color: UIColor, _ alpha: CGFloat) -> UIColor {
        return color.withAlphaComponent(alpha)
    }
}

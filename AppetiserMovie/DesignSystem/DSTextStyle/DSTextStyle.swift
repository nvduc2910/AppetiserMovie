//
//  DSTextStyle.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//

import Foundation
import UIKit

public protocol DesignSystemTextStyle {
    var font: UIFont { get set }
}

public protocol DSTextStyle: DesignSystemTextStyle {
    var color: UIColor { get }
}

public enum DS {
    
    /// Based on design system
    
    public struct mobileH0: DSTextStyle {
        public var font: UIFont = USFont.ProximaNova.semibold.font(size: 22)
        public var color: UIColor
        public init(color: UIColor = .gray) {
            self.color = color
        }
    }
    
    public struct mobileH1: DSTextStyle {
        public var font: UIFont = USFont.ProximaNova.semibold.font(size: 17)
        public var color: UIColor
        public init(color: UIColor = .gray) {
            self.color = color
        }
    }
    
    // h1 vs h2 diff the line hight
    public struct mobileH2: DSTextStyle {
        public var font: UIFont = USFont.ProximaNova.semibold.font(size: 17)
        public var color: UIColor
        public init(color: UIColor = .gray) {
            self.color = color
        }
    }
    
    public struct mobileH3: DSTextStyle {
        public var font: UIFont = USFont.ProximaNova.semibold.font(size: 15)
        public var color: UIColor
        public init(color: UIColor = .gray) {
            self.color = color
        }
    }
    
    public struct pDefault: DSTextStyle {
        public var font: UIFont = USFont.ProximaNova.regular.font(size: 15)
        public var color: UIColor
        public init(color: UIColor = .gray) {
            self.color = color
        }
    }
    
    public struct pDefault14: DSTextStyle {
        public var font: UIFont = USFont.ProximaNova.regular.font(size: 14)
        public var color: UIColor
        public init(color: UIColor = .gray) {
            self.color = color
        }
    }
    
    public struct pDefault14SemiBold: DSTextStyle {
        public var font: UIFont = USFont.ProximaNova.semibold.font(size: 14)
        public var color: UIColor
        public init(color: UIColor = .gray) {
            self.color = color
        }
    }
    
    public struct pSmall: DSTextStyle {
        public var font: UIFont = USFont.ProximaNova.regular.font(size: 12)
        public var color: UIColor
        public init(color: UIColor = .gray) {
            self.color = color
        }
    }
    
    public struct pSmallSemiBold: DSTextStyle {
        public var font: UIFont = USFont.ProximaNova.semibold.font(size: 12)
        public var color: UIColor
        public init(color: UIColor = .gray) {
            self.color = color
        }
    }
    
    public struct mobileHero: DSTextStyle {
        public var font: UIFont = USFont.ProximaNova.bold.font(size: 34)
        public var color: UIColor
        public init(color: UIColor = .gray) {
            self.color = color
        }
    }
    
    public struct mobileHero22: DSTextStyle {
        public var font: UIFont = USFont.ProximaNova.bold.font(size: 22)
        public var color: UIColor
        public init(color: UIColor = .gray) {
            self.color = color
        }
    }
    
    // Proxima Nova
    
    public struct NovaRegular: DSTextStyle {
        public var font: UIFont
        public let color: UIColor
        public init(color: UIColor = .black, fontSize: CGFloat) {
            self.color = color
            self.font = USFont.ProximaNova.regular.font(size: fontSize)
        }
    }
    
    public struct NovaBold: DSTextStyle {
        public var font: UIFont
        public let color: UIColor
        public init(color: UIColor = .black, fontSize: CGFloat) {
            self.color = color
            self.font = USFont.ProximaNova.bold.font(size: fontSize)
        }
    }
    
    public struct NovaBlack: DSTextStyle {
        public var font: UIFont
        public let color: UIColor
        public init(color: UIColor = .black, fontSize: CGFloat) {
            self.color = color
            self.font = USFont.ProximaNova.black.font(size: fontSize)
        }
    }
    
    public struct NovaExtraBold: DSTextStyle {
        public var font: UIFont
        public let color: UIColor
        public init(color: UIColor = .black, fontSize: CGFloat) {
            self.color = color
            self.font = USFont.ProximaNova.extrabold.font(size: fontSize)
        }
    }
    
    public struct NovaSemiBold: DSTextStyle {
        public var font: UIFont
        public let color: UIColor
        public init(color: UIColor = .black, fontSize: CGFloat) {
            self.color = color
            self.font = USFont.ProximaNova.semibold.font(size: fontSize)
        }
    }
    
    public struct NovaThin: DSTextStyle {
        public var font: UIFont
        public let color: UIColor
        public init(color: UIColor = .black, fontSize: CGFloat) {
            self.color = color
            self.font = USFont.ProximaNova.thin.font(size: fontSize)
        }
    }
    
    // Proxima Nova Alt
 
    public struct NovaAltThin: DSTextStyle {
        public var font: UIFont
        public let color: UIColor
        public init(color: UIColor = .black, fontSize: CGFloat) {
            self.color = color
            self.font = USFont.ProximaNovaAlt.thin.font(size: fontSize)
        }
    }
    
    public struct NovaAltBold: DSTextStyle {
        public var font: UIFont
        public let color: UIColor
        public init(color: UIColor = .black, fontSize: CGFloat) {
            self.color = color
            self.font = USFont.ProximaNovaAlt.bold.font(size: fontSize)
        }
    }
    
    public struct NovaAltLight: DSTextStyle {
        public var font: UIFont
        public let color: UIColor
        public init(color: UIColor = .black, fontSize: CGFloat) {
            self.color = color
            self.font = USFont.ProximaNovaAlt.light.font(size: fontSize)
        }
    }
}

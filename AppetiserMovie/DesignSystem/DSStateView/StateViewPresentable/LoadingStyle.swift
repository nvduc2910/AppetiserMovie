//
//  LoadingStyle.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import UIKit

public enum LoadingStyle {
    case view(UIView)
    
    public var isProgressHUD: Bool {
        return false
    }
}

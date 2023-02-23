//
//  LoadingStyle.swift
//  Upscale
//
//  Created by Duckie N on 24/11/2021.
//

import UIKit

public enum LoadingStyle {
    case view(UIView)
    
    public var isProgressHUD: Bool {
        return false
    }
}

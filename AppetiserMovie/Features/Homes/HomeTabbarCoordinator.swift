//
//  TabbarCoordinator.swift
//  AppetiserMovie
//
//  Created by Duckie N on 23/02/2023.
//

import Foundation
import UIKit

public class HomeTabbarCoordinator: BaseCoordinator {
    
    public var window: UIWindow?
    override public init() {
        super.init()
    }
    
    override func start() {
        window = UIWindow(frame: UIScreen.main.bounds)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : Colors.highLight], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : Colors.secondary], for: .normal)
        
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.rootViewController = homeViewController
        window?.makeKeyAndVisible()
        faceInEffect()
    }
    
    private func faceInEffect() {
        self.window?.makeKeyAndVisible()
        UIView.transition(with: self.window!,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}

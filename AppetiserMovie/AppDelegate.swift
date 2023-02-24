//
//  AppDelegate.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : Colors.highLight], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : Colors.secondary], for: .normal)
        
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.rootViewController = homeViewController
        window?.makeKeyAndVisible()
        faceInEffect()
        
        return true
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


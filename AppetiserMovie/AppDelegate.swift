//
//  AppDelegate.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//

import UIKit
import RxSwift
import AlamofireNetworkActivityLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 0.2)
        
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        appCoordinator = AppCoordinator()
        appCoordinator.start()
        return true
    }
}


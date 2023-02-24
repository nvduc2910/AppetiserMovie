//
//  AppCoorrdinator.swift
//  AppetiserMovie
//
//  Created by ZVN20210023 on 23/02/2023.
//

import Foundation
import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator {
    static var shared = AppCoordinator()
    
    override private init() {
        super.init()
    }
    
    override func startObservable() -> Observable<Void> {
        let tabbarCoordinator = TabbarCoordinator()
        return self.coordinate(to: tabbarCoordinator)
    }
    
//    public func startHomeView() -> (BaseCoordinator, UIViewController) {
//        let coordinator = HomeViewCoordinator()
//        addDependency(coordinator)
//        return (coordinator, coordinator.start())
//    }
//    
//    public func startFavoriteView() -> (BaseCoordinator, UIViewController) {
//        let coordinator = FavoriteViewCoordinator()
//        addDependency(coordinator)
//        return (coordinator, coordinator.start())
//    }
}

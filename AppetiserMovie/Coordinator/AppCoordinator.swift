//
//  AppCoorrdinator.swift
//  AppetiserMovie
//
//  Created by Duckie N on 23/02/2023.
//

import Foundation
import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator {
    static var shared = AppCoordinator()
    
    override public init() {
        super.init()
    }
    
    override func start() {
        let tabbarCoordinator = HomeTabbarCoordinator()
        tabbarCoordinator.start()
        self.addDependency(tabbarCoordinator)
    }
    
    func startFavoritedMovieCoordinator(navigationController: UINavigationController) -> UIViewController {
        let favoritedMovieCoordinator = FavoritedMovieCoordinator(navigationController: navigationController)
        favoritedMovieCoordinator.start()
        return favoritedMovieCoordinator.viewController
    }
    
    func startMovieListCoordinator(navigationController: UINavigationController) -> UIViewController {
        let movieListCoordinator = MovieListCoordinator(navigationController: navigationController)
        movieListCoordinator.start()
        return movieListCoordinator.viewController
    }
}

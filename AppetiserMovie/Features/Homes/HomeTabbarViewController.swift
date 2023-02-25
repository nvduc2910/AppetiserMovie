//
//  HomeTabbarViewController.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//

import UIKit
import RxSwift

class HomeTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var disposeBag = DisposeBag()
}

class MovieListUINavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let movieListViewController = AppCoordinator.shared.startMovieListCoordinator(navigationController: self)
        setViewControllers([movieListViewController], animated: false)
    }
}

class FavoriteUINavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let favoriteListViewController = AppCoordinator.shared.startFavoritedMovieCoordinator(navigationController: self)
        setViewControllers([favoriteListViewController], animated: false)
    }
}

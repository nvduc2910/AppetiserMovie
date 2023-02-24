//
//  HomeTabbarViewController.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//

import UIKit

class HomeTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class MovieListUINavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([MovieListViewController()], animated: false)
    }
}

class FavoriteUINavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([FavoritedMovieViewController()], animated: false)
    }
}

//
//  FavoritedMovieCoordinator.swift
//  AppetiserMovie
//
//  Created by Duckie N on 25/02/2023.
//

import Foundation
import UIKit

public class FavoritedMovieCoordinator: BaseCoordinator {
    
    public var viewController: UIViewController!
    var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let favoriteListViewController = FavoritedMovieViewController()
        let viewModel = FavoriteListViewModel()
        favoriteListViewController.viewModel = viewModel
        
        viewModel.output
            .showMovieDetail
            .subscribeNext { item in
                self.showMovieDetail(item)
            }
            .disposed(by: disposeBag)
        self.viewController = favoriteListViewController
    }
    
    func showMovieDetail(_ item: MovieItemUIModel) {
        let movieDetailCoordinator = MovieDetailCoordinator(movie: item,
                                                            navigationController: self.navigationController)
        movieDetailCoordinator.start()
    }
}

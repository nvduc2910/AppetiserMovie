//
//  MovieListCoordinator.swift
//  AppetiserMovie
//
//  Created by ZVN20210023 on 25/02/2023.
//

import Foundation
import UIKit

public class MovieListCoordinator: BaseCoordinator {
    
    public var viewController: UIViewController!
    var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let movieListViewController = MovieListViewController()
        let viewModel = MovieListViewModel(searchService: SearchItemService.default,
                                           favoriteService: FavoriteService.default)
        movieListViewController.viewModel = viewModel
        
        viewModel.output
            .showMovieDetail
            .subscribeNext { item in
                self.showMovieDetail(item)
            }
            .disposed(by: disposeBag)
        
        viewModel.output
            .showSearchScreen
            .subscribeNext { item in
                self.showSearchScreen()
            }
            .disposed(by: disposeBag)
        
        self.viewController = movieListViewController
    }
    
    func showMovieDetail(_ item: MovieItemUIModel) {
        let movieDetailCoordinator = MovieDetailCoordinator(movie: item,
                                                            navigationController: self.navigationController)
        movieDetailCoordinator.start()
    }
    
    func showSearchScreen() {
        let searchScreenCoordinator = SearchCoordinator(navigationController: navigationController)
        searchScreenCoordinator.start()
    }
}

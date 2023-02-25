//
//  MovieDetailCoordinator.swift
//  AppetiserMovie
//
//  Created by Duckie N on 25/02/2023.
//

import Foundation
import UIKit

public class MovieDetailCoordinator: BaseCoordinator {
    
    let movie: MovieItemUIModel
    var navigationController: UINavigationController
    
    public init(movie: MovieItemUIModel,
                navigationController: UINavigationController) {
        self.movie = movie
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let movieDetailViewController = MovieDetailViewController()
        let movieDetailViewModel = MovieDetailViewModel(movie: movie)
        movieDetailViewController.viewModel = movieDetailViewModel
        self.navigationController.pushViewController(movieDetailViewController, animated: true)
    }
}

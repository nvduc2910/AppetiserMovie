//
//  SearchCoordinator.swift
//  AppetiserMovie
//
//  Created by ZVN20210023 on 25/02/2023.
//

import Foundation
import UIKit

public class SearchCoordinator: BaseCoordinator {
    
    var navigationController: UINavigationController
    
    var naviSearchViewController: UINavigationController?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let searchViewController = SearchViewController()
        let viewModel = MovieListViewModel(searchService: SearchItemService.default, favoriteService: FavoriteService.default)
        searchViewController.viewModel = viewModel
        
        viewModel.output
            .showMovieDetail
            .subscribeNext { item in
                self.showMovieDetail(item)
            }
            .disposed(by: disposeBag)
        
        viewModel.output
            .closeScreen
            .subscribeNext { item in
                self.naviSearchViewController?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        let naviSearch = CustomUINavigationController(rootViewController: searchViewController)
        naviSearch.modalPresentationStyle = .fullScreen
        naviSearch.isNavigationBarHidden = true
        naviSearchViewController = naviSearch
        self.navigationController.present(naviSearch, animated: true)
    }
    
    func showMovieDetail(_ item: MovieItemUIModel) {
        let movieDetailCoordinator = MovieDetailCoordinator(movie: item,
                                                            navigationController: naviSearchViewController ?? navigationController)
        movieDetailCoordinator.start()
    }
}

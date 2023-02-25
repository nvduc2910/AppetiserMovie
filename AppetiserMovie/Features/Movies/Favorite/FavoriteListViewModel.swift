//
//  FavoriteListViewModel.swift
//  AppetiserMovie
//
//  Created by Duckie N  on 24/02/2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import Action

struct FavoriteListViewModelInput {
    var removeFavoriteTrigger: PublishRelay<MovieItemUIModel>
    var viewViewAppear = PublishRelay<Void>()
    var didTapItem = PublishRelay<Int>()
}

struct FavoriteListViewModelOutput {
    let itemsStream: BehaviorRelay<[MovieItemUIModel]>
    let showMovieDetail: PublishRelay<MovieItemUIModel>
}

final class FavoriteListViewModel: BaseViewModel {
    
    let input: FavoriteListViewModelInput
    let output: FavoriteListViewModelOutput
    
    // MARK: - input ref
    var removeFavoriteTrigger = PublishRelay<MovieItemUIModel>()
    
    // MARK: - output ref
    let itemsRelay = BehaviorRelay<[MovieItemUIModel]>(value: [])
    let showMovieDetail = PublishRelay<MovieItemUIModel>()
    
    private var disposeBag = DisposeBag()
    
    var favoriteService: FavoriteServiceType
    
    init(favoriteService: FavoriteServiceType = FavoriteService.default) {
        self.favoriteService = favoriteService
        
        input = FavoriteListViewModelInput(removeFavoriteTrigger: removeFavoriteTrigger)
        output = FavoriteListViewModelOutput(itemsStream: itemsRelay, showMovieDetail: showMovieDetail)
        
        configureInput()
        updateItemsRelay()
    }
    
    func configureInput() {
        removeFavoriteTrigger.subscribeNext { [weak self] item in
            guard let self = self else { return }
            
            if item.isFavorite {
                self.favoriteService.removeItem(movie: item.transformToMovie())
                self.updateItemsRelay()
            }
        }.disposed(by: disposeBag)
        
        input.didTapItem
            .withLatestFrom(self.itemsRelay) { ($0, $1) }
            .map { index, items -> MovieItemUIModel in
                return items[index]
            }
            .bind(to: self.showMovieDetail)
            .disposed(by: disposeBag)
    }
    
    func updateItemsRelay() {
        favoriteService.getMovies()
            .filterNil()
            .map({ movies -> [MovieItemUIModel] in
                return movies.map({ return $0.transformToUIModel() })
            })
            .bind(to: itemsRelay)
            .disposed(by: disposeBag)
    }
    
    func viewDidLoad() {}
}

//
//  FavoriteListViewModel.swift
//  AppetiserMovie
//
//  Created by ZVN20210023 on 24/02/2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import Action

struct FavoriteListViewModelInput {
    var removeFavoriteTrigger: PublishRelay<MovieItemUIModel>
    var viewViewAppear = PublishRelay<Void>()
}

struct FavoriteListViewModelOutput {
    let itemsStream: BehaviorRelay<[MovieItemUIModel]>
}

final class FavoriteListViewModel: BaseViewModel {
    
    let input: FavoriteListViewModelInput
    let output: FavoriteListViewModelOutput
    
    // MARK: - input ref
    var removeFavoriteTrigger = PublishRelay<MovieItemUIModel>()
    
    // MARK: - output ref
    let itemsRelay = BehaviorRelay<[MovieItemUIModel]>(value: [])
    
    private var disposeBag = DisposeBag()
    
    var favoriteService: FavoriteServiceType
    
    init(favoriteService: FavoriteServiceType = FavoriteService.default) {
        self.favoriteService = favoriteService
        
        input = FavoriteListViewModelInput(removeFavoriteTrigger: removeFavoriteTrigger)
        output = FavoriteListViewModelOutput(itemsStream: itemsRelay)
        
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
    }
    
    func updateItemsRelay() {
        favoriteService.getMovies()
            .map({ movies -> [MovieItemUIModel] in
                return movies.map({ return $0.transformToUIModel() })
            })
            .bind(to: itemsRelay)
            .disposed(by: disposeBag)
    }
    
    func viewDidLoad() {}
}

//
//  MovieListViewModel.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import Action

protocol MovieListViewModelType {
    
}

struct MovieListViewModelInput {
    var favoriteTrigger: PublishRelay<MovieItemUIModel>
    var searchTrigger: PublishRelay<String>
    var didTapItem = PublishRelay<Int>()
    var didTapSearch = PublishRelay<Void>()
}

struct MovieListViewModelOutput {
    let itemsStream: BehaviorRelay<[MovieItemUIModel]>
    let errorStream: PublishRelay<ActionError>
    let isLoadingStream: PublishRelay<Bool>
    
    let showMovieDetail: PublishRelay<MovieItemUIModel>
    let showSearchScreen: PublishRelay<Void>
}

public struct MovieItemUIModel {
    let trackName: String
    var isFavorite: Bool
    let artworkUrl: URL?
    let trackPrice: Double?
    let country: String?
    let currency: String?
    let shortDescription: String?
    let longDescription: String?
    let id: Int
    let genreName: String?
    
    func transformToMovie() -> Movie {
        return Movie(trackName: trackName,
                     artworkUrl: artworkUrl,
                     trackPrice: trackPrice,
                     country: country,
                     currency: currency,
                     shortDescription: shortDescription,
                     longDescription: longDescription,
                     id: id,
                     genreName: genreName,
                     isFavorite: isFavorite)
    }
}

final class MovieListViewModel: BaseViewModel, MovieListViewModelType {
    
    let input: MovieListViewModelInput
    let output: MovieListViewModelOutput
    
    // MARK: - input ref
    var favoriteTrigger = PublishRelay<MovieItemUIModel>()
    var searchTrigger = PublishRelay<String>()
    
    // MARK: - output ref
    let itemsRelay = BehaviorRelay<[MovieItemUIModel]>(value: [])
    let errorPublish = PublishRelay<ActionError>()
    let isLoadingPublish = PublishRelay<Bool>()
    let showMovieDetail = PublishRelay<MovieItemUIModel>()
    let showSearchScreen = PublishRelay<Void>()
    
    private var disposeBag = DisposeBag()
    private var getAPIRelay = PublishRelay<Void>()
    
    let searchService: SearchItemServiceType
    let favoriteService: FavoriteServiceType
    
    let defaultQuery = "star"
    
    // MARK: - api call
    
    private lazy var getMovieAction = Action<String, [Movie]> { [unowned self] query in
        return self.searchService.searchItem(query: query).asObservable().take(until: getAPIRelay.asObservable())
    }
    
    init(searchService: SearchItemServiceType,
         favoriteService: FavoriteServiceType) {
        self.searchService = searchService
        self.favoriteService = favoriteService
        
        input = MovieListViewModelInput(favoriteTrigger: favoriteTrigger,
                                        searchTrigger: searchTrigger)
        output = MovieListViewModelOutput(itemsStream: itemsRelay,
                                          errorStream: errorPublish,
                                          isLoadingStream: isLoadingPublish,
                                          showMovieDetail: showMovieDetail,
                                          showSearchScreen: showSearchScreen)
        
        configureInput()
        configureOutput()
        configureGetMovieList()
    }
    
    func configureInput() {
        favoriteTrigger.subscribeNext { [weak self] item in
            guard let self = self else { return }
            
            let isFavorite = item.isFavorite
            var items = self.itemsRelay.value
            if let index = items.firstIndex(where: { $0.id == item.id }) {
                items[index].isFavorite.toggle()
                self.itemsRelay.accept(items)
            }
            
            isFavorite ? self.favoriteService.removeItem(movie: item.transformToMovie()) : self.favoriteService.saveItem(movie: item.transformToMovie())
        }.disposed(by: disposeBag)
        
        searchTrigger.subscribeNext { [weak self] keyword in
            guard let self = self else { return }
            self.isLoadingPublish.accept(true)
            self.getAPIRelay.accept(())
            self.getMovieAction.execute(keyword)
        }.disposed(by: disposeBag)
        
        input.didTapItem
            .withLatestFrom(self.itemsRelay) { ($0, $1) }
            .map { index, items -> MovieItemUIModel in
                return items[index]
            }
            .bind(to: self.showMovieDetail)
            .disposed(by: disposeBag)
        
        input.didTapSearch
            .bind(to: self.showSearchScreen)
            .disposed(by: disposeBag)
    }
    
    func configureOutput() {
        
    }

    func configureGetMovieList() {
        getMovieAction.elements.subscribeNext { [weak self] items in
            guard let self = self else { return }
            let itemsTransform = items.map({ return $0.transformToUIModel() })
            self.itemsRelay.accept(itemsTransform)
            self.isLoadingPublish.accept(false)
        }.disposed(by: disposeBag)
        
        getMovieAction.errors.subscribeNext { [weak self] error in
            guard let self = self else { return }
            self.errorPublish.accept(error)
        }.disposed(by: disposeBag)
    }
    
    func viewDidLoad() {
        isLoadingPublish.accept(true)
        getAPIRelay.accept(())
        getMovieAction.execute(defaultQuery)
    }
}

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
}

struct MovieListViewModelOutput {
    let itemsStream: BehaviorRelay<[MovieItemUIModel]>
    let errorStream: PublishRelay<ActionError>
    let isLoadingStream: PublishRelay<Bool>
}

struct MovieItemUIModel {
    let trackName: String
    var isFavorite: Bool
    let artworkUrl: URL?
    let trackPrice: Double?
    let country: String?
    let currency: String?
    let shortDescription: String?
    let longDescription: String?
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
    
    private var disposeBag = DisposeBag()
    private var getAPIRelay = PublishRelay<Void>()
    
    var searchService: SearchItemServiceType
    
    // MARK: - api call
    
    private lazy var getMovieAction = Action<String, [Movie]> { [unowned self] query in
        return self.searchService.searchItem(query: query).asObservable().take(until: getAPIRelay.asObservable())
    }
    
    init(searchService: SearchItemServiceType) {
        self.searchService = searchService
        
        input = MovieListViewModelInput(favoriteTrigger: favoriteTrigger,
                                        searchTrigger: searchTrigger)
        output = MovieListViewModelOutput(itemsStream: itemsRelay,
                                          errorStream: errorPublish,
                                          isLoadingStream: isLoadingPublish)
        
        configureInput()
        configureOutput()
        configureGetMovieList()
    }
    
    func configureInput() {
        favoriteTrigger.subscribeNext { [weak self] item in
            guard let self = self else { return }
            
            if item.isFavorite {
                // remove favorite from cache list
            } else {
                // add favorite to cache list
            }
            
            var items = self.itemsRelay.value
            if let index = items.firstIndex(where: { $0.trackName == item.trackName }) {
                items[index].isFavorite.toggle()
                self.itemsRelay.accept(items)
            }
        }.disposed(by: disposeBag)
        
        searchTrigger.subscribeNext { [weak self] keyword in
            guard let self = self else { return }
            self.isLoadingPublish.accept(true)
            self.getAPIRelay.accept(())
            self.getMovieAction.execute(keyword)
        }.disposed(by: disposeBag)
    }
    
    func configureOutput() {
        
    }

    func configureGetMovieList() {
        getMovieAction.elements.subscribeNext { [weak self] items in
            guard let self = self else { return }
            let itemsTransform = items.map({ return MovieItemUIModel(trackName: $0.trackName.orEmpty,
                                                                     isFavorite: false,
                                                                     artworkUrl: $0.artworkUrl,
                                                                     trackPrice: $0.trackPrice,
                                                                     country: $0.country,
                                                                     currency: $0.country,
                                                                     shortDescription: $0.shortDescription,
                                                                     longDescription: $0.longDescription) })
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
        getMovieAction.execute("star")
    }
}

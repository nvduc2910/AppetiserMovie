//
//  MovieDetailViewModel.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import Foundation
import RxSwift
import RxCocoa

struct MovieDetailViewModelInput {
    var favoriteTrigger: PublishRelay<MovieItemUIModel>
}

struct MovieDetailViewModelOutput {
    var movieSection: BehaviorRelay<[MovieSectionType]>
}

enum MovieSectionType {
    case summary(MovieItemUIModel)
    case description(String)
}

protocol MovieDetailViewModelType {
    var input: MovieDetailViewModelInput { get }
    var output: MovieDetailViewModelOutput { get }
}

final class MovieDetailViewModel: BaseViewModel, MovieDetailViewModelType {
    
    var movie: MovieItemUIModel
    let input: MovieDetailViewModelInput
    let output: MovieDetailViewModelOutput
    
    private var disposeBag = DisposeBag()
    let favoriteService: FavoriteServiceType
    
    // MARK: - input ref
    
    var favoriteTrigger = PublishRelay<MovieItemUIModel>()
    
    // MARK: - output ref
    
    var movieSection = BehaviorRelay<[MovieSectionType]>(value: [])
    
    init(movie: MovieItemUIModel,
         favoriteService: FavoriteServiceType = FavoriteService.default) {
        self.favoriteService = favoriteService
        self.movie = movie
        
        input = MovieDetailViewModelInput(favoriteTrigger: favoriteTrigger)
        output = MovieDetailViewModelOutput(movieSection: movieSection)
        
        configureInput()
    }
    
    func configureInput() {
        favoriteTrigger.subscribeNext { [weak self] item in
            guard let self = self else { return }
            item.isFavorite ? self.favoriteService.removeItem(movie: item.transformToMovie()) : self.favoriteService.saveItem(movie: item.transformToMovie())
            self.movie.isFavorite.toggle()
            self.viewDidLoad()
        }.disposed(by: disposeBag)
    }
    
    func viewDidLoad() {
        var sections: [MovieSectionType] = []
        sections.append(.summary(movie))
        sections.append(.description(movie.longDescription.orEmpty))
        
        movieSection.accept(sections)
    }
}

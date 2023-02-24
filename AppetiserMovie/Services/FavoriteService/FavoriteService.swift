//
//  FavoriteService.swift
//  AppetiserMovie
//
//  Created by Duckie N on 24/02/2023.
//

import Foundation
import RxSwift

protocol FavoriteServiceType {
    func saveItem(movie: Movie)
    func removeItem(movie: Movie)
    func getMovies() -> Observable<[Movie]>
}

class FavoriteService: FavoriteServiceType {
    
    static let `default` = FavoriteService()
    let cacheService: CacheServiceType
    
    init(cacheService: CacheServiceType = CacheService.default) {
        self.cacheService = cacheService
    }
    
    func saveItem(movie: Movie) {
        var movies = self.getCacheMovies()
        var movie = movie
        movie.isFavorite = true
        movies.append(movie)
        cacheService.saveObject(movies, for: .movies)
    }
    
    func removeItem(movie: Movie) {
        var movies = self.getCacheMovies()
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies.remove(at: index)
            cacheService.saveObject(movies, for: .movies)
        }
    }
    
    var disposeBag = DisposeBag()
    
    func getCacheMovies() -> [Movie] {
        let movies: [Movie]? = cacheService.getObject(for: .movies)
        return movies ?? []
    }
    
    func getMovies() -> Observable<[Movie]> {
        let data: Observable<[Movie]?> = cacheService.getObject(for: .movies)
        return data.filterNil()
    }
}

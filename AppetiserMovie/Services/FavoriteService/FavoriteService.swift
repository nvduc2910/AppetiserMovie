//
//  FavoriteService.swift
//  AppetiserMovie
//
//  Created by Duckie N on 24/02/2023.
//

import Foundation

protocol FavoriteServiceType {
    func saveItem(movie: Movie)
    func removeItem(movie: Movie)
    func getMovies() -> [Movie]
}

class FavoriteService: FavoriteServiceType {
    
    static let `default` = FavoriteService()
    let cacheService: CacheServiceType
    
    init(cacheService: CacheServiceType = CacheService.default) {
        self.cacheService = cacheService
    }
    
    func saveItem(movie: Movie) {
        var movies = self.getMovies()
        var movie = movie
        movie.isFavorite = true
        movies.append(movie)
        cacheService.saveObject(movies, for: .movies)
    }
    
    func removeItem(movie: Movie) {
        var movies = self.getMovies()
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies.remove(at: index)
            cacheService.saveObject(movies, for: .movies)
        }
    }
    
    func getMovies() -> [Movie] {
        let movies: [Movie]? = cacheService.getObject(for: .movies)
        return movies ?? []
    }
}

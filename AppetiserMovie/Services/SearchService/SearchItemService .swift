//
//  SearchItemService .swift
//  AppetiserMovie
//
//  Created by Duckie N on 23/02/2023.
//

import Foundation
import RxSwift

protocol SearchItemServiceType {
    func searchItem(query: String) -> Single<[Movie]>
}

class SearchItemService: SearchItemServiceType {
    
    static let `default` = SearchItemService()
    
    let api: APIType
    let cacheService: CacheServiceType
    
    init(api: APIType = API.default,
         cacheService: CacheServiceType = CacheService.default) {
        self.api = api
        self.cacheService = cacheService
    }
    
    func searchItem(query: String) -> Single<[Movie]> {
        let searchTarget = SearchTarget(query: query)
        let data: Single<[Movie]> = api.request(target: searchTarget)
        return data.asObservable().map({ [weak self] movies -> [Movie] in
            var movies = movies
            self?.updateFavorites(movies: &movies)
            return movies
        }).asSingle()
    }
    
    func updateFavorites(movies: inout [Movie]) {
        let favorite: [Movie]? = cacheService.getObject(for: .movies)
        let commonIds = Set((favorite ?? []).map { $0.id })
        movies.indices.forEach { index in
            var movieIndex = movies[index]
            movieIndex.isFavorite = commonIds.contains(movieIndex.id)
            movies[index] = movieIndex
        }
    }
}

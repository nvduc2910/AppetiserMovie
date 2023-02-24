//
//  SearchItemService .swift
//  AppetiserMovie
//
//  Created by Duckie N on 23/02/2023.
//

import Foundation
import RxSwift

protocol SearchItemServiceType {
    func searchItem(query: String) -> Observable<[Movie]>
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
    
    func searchItem(query: String) -> Observable<[Movie]> {
        let searchTarget = SearchTarget(query: query)
        let data: Single<[Movie]> = api.request(target: searchTarget)
        let movies: Observable<[Movie]?> = cacheService.getObject(for: .movies)
        
        return movies
            .flatMapLatest { cacheData -> Single<[Movie]> in
                return data.map { remoteData -> [Movie] in
                    var movies = remoteData
                    self.updateFavorites(movies: &movies, cacheData: cacheData)
                    return movies
                }
            }
            .asObservable()
    }
    
    func searchItemNew(query: String) -> Observable<[Movie]> {
        let searchTarget = SearchTarget(query: query)
        let data: Single<[Movie]> = api.request(target: searchTarget)
        let movies: Observable<[Movie]?> = cacheService.getObject(for: .movies)
        
        return movies
            .flatMapLatest { cacheData -> Single<[Movie]> in
                return data.map { remoteData -> [Movie] in
                    var movies = remoteData
                    self.updateFavorites(movies: &movies, cacheData: cacheData)
                    return movies
                }
            }
            .asObservable()
    }
    
    func updateFavorites(movies: inout [Movie], cacheData: [Movie]?) {
        let commonIds = Set((cacheData ?? []).map { $0.id })
        movies.indices.forEach { index in
            var movieIndex = movies[index]
            movieIndex.isFavorite = commonIds.contains(movieIndex.id)
            movies[index] = movieIndex
        }
    }
}

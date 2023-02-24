//
//  SearchItemTarget.swift
//  AppetiserMovie
//
//  Created by ZVN20210023 on 23/02/2023.
//

import Foundation
import Alamofire

struct SearchTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        return .get
    }
    enum MediaType {
        static let movie: String = "movie"
        // We can add more type like music, podcast, ebook...
    }
    
    var path: String {
        return NetworkingConfig.EndpointURL.searchPath
    }
    
    var parameter: [String: Any]? {
        let params: [String: Any] = [
            "term": query,
            "limit": limit,
            "media": media,
            "country": country
        ]
        return params
    }
    
    let query: String
    let limit: Int
    let media: String
    let country: String
    
    init(query: String,
         limit: Int = 50,
         media: String = MediaType.movie,
         country: String = "au") {
        self.query = query
        self.limit = limit
        self.media = media
        self.country = country
    }
}

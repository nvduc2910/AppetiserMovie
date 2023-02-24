//
//  APIResponse.swift
//  AppetiserMovie
//
//  Created by Duckie N on 23/02/2023.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let resultCount: Int
    let results: T
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode(T.self, forKey: .results)
        resultCount = try container.decode(Int.self, forKey: .resultCount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(results, forKey: .results)
        try container.encode(resultCount, forKey: .resultCount)
    }
}

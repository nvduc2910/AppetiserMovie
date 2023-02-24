//
//  Movie.swift
//  AppetiserMovie
//
//  Created by ZVN20210023 on 23/02/2023.
//

import Foundation

struct Movie: Codable {
    let trackName: String?
    let artworkUrl: URL?
    let trackPrice: Double?
    let country: String?
    let currency: String?
    let shortDescription: String?
    let longDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case trackName
        case artworkUrl = "artworkUrl100"
        case trackPrice
        case country
        case currency
        case shortDescription
        case longDescription
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        trackName = try container.decodeIfPresent(String.self, forKey: .trackName)
        artworkUrl = try container.decodeIfPresent(URL.self, forKey: .artworkUrl)
        trackPrice = try container.decodeIfPresent(Double.self, forKey: .trackPrice)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        currency = try container.decodeIfPresent(String.self, forKey: .currency)
        shortDescription = try container.decodeIfPresent(String.self, forKey: .shortDescription)
        longDescription = try container.decodeIfPresent(String.self, forKey: .longDescription)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(trackName, forKey: .trackName)
        try container.encodeIfPresent(artworkUrl, forKey: .artworkUrl)
        try container.encodeIfPresent(trackPrice, forKey: .trackPrice)
        try container.encodeIfPresent(country, forKey: .country)
        try container.encodeIfPresent(currency, forKey: .currency)
        try container.encodeIfPresent(shortDescription, forKey: .shortDescription)
        try container.encodeIfPresent(longDescription, forKey: .longDescription)
    }
}

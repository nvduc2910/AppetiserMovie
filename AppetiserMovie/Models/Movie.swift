//
//  Movie.swift
//  AppetiserMovie
//
//  Created by Duckie N on 23/02/2023.
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
    let id: Int
    let genreName: String?
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case trackName
        case artworkUrl = "artworkUrl100"
        case trackPrice
        case country
        case currency
        case shortDescription
        case longDescription
        case id = "trackId"
        case genreName = "primaryGenreName"
        case isFavorite
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
        id = try container.decode(Int.self, forKey: .id)
        genreName = try container.decodeIfPresent(String.self, forKey: .genreName)
        isFavorite = (try? container.decodeIfPresent(Bool.self, forKey: .isFavorite)) ?? false
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
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(genreName, forKey: .genreName)
        try container.encodeIfPresent(isFavorite, forKey: .isFavorite)
    }
    
    public init (trackName: String? = nil,
                 artworkUrl: URL? = nil,
                 trackPrice: Double? = nil,
                 country: String? = nil,
                 currency: String? = nil,
                 shortDescription: String? = nil,
                 longDescription: String? = nil,
                 id: Int,
                 genreName: String? = nil,
                 isFavorite: Bool = false) {
        self.trackName = trackName
        self.artworkUrl = artworkUrl
        self.trackPrice = trackPrice
        self.country = country
        self.currency = currency
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.id = id
        self.genreName = genreName
        self.isFavorite = isFavorite
        
    }
}

extension Movie {
    func transformToUIModel() -> MovieItemUIModel {
        return MovieItemUIModel(trackName: self.trackName.orEmpty,
                                isFavorite: self.isFavorite,
                                artworkUrl: self.artworkUrl,
                                trackPrice: self.trackPrice,
                                country: self.country,
                                currency: self.currency,
                                shortDescription: self.shortDescription,
                                longDescription: self.longDescription,
                                id: self.id,
                                genreName: self.genreName)
    }
}


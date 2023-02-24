//
//  CacheService.swift
//  AppetiserMovie
//
//  Created by Duckie N on 24/02/2023.
//

import Foundation

protocol CacheServiceType {
    func saveObject<T: Codable>(_ data: T, for key: UserAppSettingsKey)
    func getObject<T: Codable>(for key: UserAppSettingsKey) -> T?
}

public class CacheService: CacheServiceType {
    
    static let `default` = CacheService()

    let userDefault: UserDefaults
    public init(userDefault: UserDefaults = UserDefaults.standard) {
        self.userDefault = userDefault
    }
    
    func saveObject<T>(_ data: T, for key: UserAppSettingsKey) where T : Decodable, T : Encodable {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            userDefault.set(encoded, forKey: key.name)
        }
    }
    
    func getObject<T>(for key: UserAppSettingsKey) -> T? where T : Decodable, T : Encodable {
        if let data = userDefault.object(forKey: key.name) as? Data {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(T.self, from: data) {
                return object
            }
        }
        return nil
    }
}

public enum UserAppSettingsKey: Int, CaseIterable {
    case movies
    var name: String {
        switch self {
            case .movies: return "movies"
        }
    }
}

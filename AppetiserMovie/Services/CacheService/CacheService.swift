//
//  CacheService.swift
//  AppetiserMovie
//
//  Created by Duckie N on 24/02/2023.
//

import Foundation
import RxSwift
import RxRelay

protocol CacheServiceType {
    func saveObject<T: Codable>(_ data: T, for key: UserAppSettingsKey)
    func getObject<T: Codable>(for key: UserAppSettingsKey) -> T?
    func getObject<T: Codable>(for key: UserAppSettingsKey) -> Observable<T?>
}

public class CacheService: NSObject, CacheServiceType {
    
    static let `default` = CacheService()
    
    let userDefault: UserDefaults
    var valueChange = PublishRelay<String>()
    var observerKeys: [String] = []
    
    public init(userDefault: UserDefaults = UserDefaults.standard) {
        self.userDefault = userDefault
        super.init()
        UserAppSettingsKey.allCases.map { $0.name }.forEach { [weak self] key in
            self?.addObserver(key: key)
        }
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
    
    func getObject<T>(for key: UserAppSettingsKey) -> RxSwift.Observable<T?> where T : Decodable, T : Encodable {
        return valueChange.asObservable().filter({ $0 == key.name }).startWith("")
            .map { [weak self] _ -> T? in
                if let data = self?.userDefault.object(forKey: key.name) as? Data {
                    let decoder = JSONDecoder()
                    if let object = try? decoder.decode(T.self, from: data) {
                        return object
                    }
                }
                return nil
            }
    }
    
    private func removeObserver(key: String) {
        if let index = observerKeys.firstIndex(where: { $0 == key }) {
            userDefault.removeObserver(self, forKeyPath: key)
            observerKeys.remove(at: index)
        }
    }
    
    private func addObserver(key: String) {
        removeObserver(key: key)
        userDefault.addObserver(self, forKeyPath: key, options: .new, context: nil)
        observerKeys.append(key)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = keyPath,
           UserAppSettingsKey.allCases.map({ $0.name }).contains(key) {
            valueChange.accept(key)
        }
    }
    
    deinit {
        UserAppSettingsKey.allCases.map { $0.name }.forEach { key in
            userDefault.removeObserver(self, forKeyPath: key)
        }
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

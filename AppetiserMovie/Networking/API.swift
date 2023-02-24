//
//  API.swift
//  AppetiserMovie
//
//  Created by Duckie N on 23/02/2023.
//

import Foundation
import Alamofire
import RxSwift

protocol APIType {
    /// Request networking API
    ///
    /// - Parameters:
    ///   - target: Target to request
    /// - Returns: An observable sequence containing the single Response.
    func request<T: Codable>(target: TargetType) -> Single<T>
}

class API: APIType {
    
    static let `default` = API()
    
    init() {}
    
    func request<T: Codable>(target: TargetType) -> Single<T> {
        let url = target.baseURL.appendingPathComponent(target.path)
        return Single<T>.create { single in
            AF.request(url, method: target.method, parameters: target.parameter, headers: HTTPHeaders(target.headers ?? [:])).responseDecodable(of: APIResponse<T>.self) { (response) in
                switch response.result {
                case .success(let resultData):
                    let data = resultData.results
                    single(.success(data))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}

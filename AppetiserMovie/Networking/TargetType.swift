//
//  TargetType.swift
//  AppetiserMovie
//
//  Created by ZVN20210023 on 23/02/2023.
//

import Foundation
import Alamofire

public protocol TargetType {

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Alamofire.HTTPMethod { get }
    
    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    var parameter: [String: Any]? { get }
}

extension TargetType {
    var baseURL: URL {
        guard let url = URL(string: NetworkingConfig.EndpointURL.baseURL) else {
            fatalError("URL is incorrect. Please check again")
        }
        return url
    }
    
    var headers: [String: String]? {
        let headers = ["accept": "Application/json"]
        return headers
    }
}

enum NetworkingConfig {
    enum EndpointURL {
        static let baseURL: String = "https://itunes.apple.com"
        static let searchPath: String = "search"
        static let detailPath: String = "detail"
    }
}

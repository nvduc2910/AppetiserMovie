//
//  SearchItemService .swift
//  AppetiserMovie
//
//  Created by ZVN20210023 on 23/02/2023.
//

import Foundation
import RxSwift

protocol SearchItemServiceType {
    func searchItem(query: String) -> Single<[Movie]>
}

class SearchItemService: SearchItemServiceType {
    
    static let `default` = SearchItemService()
    
    let api: APIType
    init(api: APIType = API.default) {
        self.api = api
    }
    
    func searchItem(query: String) -> Single<[Movie]> {
        let searchTarget = SearchTarget(query: query)
        return api.request(target: searchTarget)
    }
}

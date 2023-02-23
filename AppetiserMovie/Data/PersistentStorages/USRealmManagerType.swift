//
//  RealmManagerType.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//

import Foundation
import RealmSwift
import RxOptional
import RxRealm
import RxSwift

public protocol USRealmManagerType: AnyObject {
    
    func object<T: Object, KeyType>(_ type: T.Type, forPrimaryKey: KeyType) -> T?
    func object<T: Object>(_ type: T.Type, id: T.Identity) -> T? where T: IdentifiableObject
    func object<T: Object>(_ type: T.Type, filter predicate: NSPredicate) -> T?
    func objects<T: Object>(_ type: T.Type) -> Results<T>
    func objects<T: Object>(_ type: T.Type, filter predicate: NSPredicate) -> Results<T>

    func observableObject<T: Object>(_ type: T.Type, id: T.Identity) -> Observable<T> where T: IdentifiableObject
    func observableObjects<T: Object>(_ type: T.Type) -> Observable<Results<T>>
    func observableObjects<T: Object>(_ type: T.Type, filter predicate: NSPredicate) -> Observable<Results<T>>

    func create(object: Object, update: Bool)
    func create(objects: [Object], update: Bool)
    func create<T: Object>(_ type: T.Type, value: Any, update: Bool)

    func delete<T: RealmSwift.Object>(object: T)
    func delete<T: Object>(objects: RealmSwift.Results<T>)
    func delete<T: Object>(list: RealmSwift.List<T>)
    func delete<T: Object>(type: T.Type)
    func delete<T: Object>(array: [T])

    func clearData()
    func asyncCreate(objects: [Object], update: Bool, completion: (() -> Void)?)
}

public extension USRealmManagerType {

    func create(object: Object, update: Bool = false) {
        asyncCreate(objects: [object], update: update, completion: nil)
    }

    func create(objects: [Object], update: Bool = false) {
        asyncCreate(objects: objects, update: update, completion: nil)
    }
}

//
//  RealmManager.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//

import Foundation
import RealmSwift
import RxOptional
import RxRealm
import RxSwift

final class Atomic<A> {
    private let queue = DispatchQueue(label: "atomic.serial.queue")
    private var _value: A

    init(_ value: A) {
        self._value = value
    }

    var value: A {
        return queue.sync { self._value }
    }

    func mutate(_ transform: (inout A) -> Void) {
        queue.sync { transform(&self._value) }
    }
}

extension USRealmManager {
    static let buildNumber: UInt64 = {
        guard let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            fatalError("Cannot get App build number")
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        guard let number = formatter.number(from: build) else {
            fatalError("Cannot get App build number")
        }
        return UInt64(number.intValue)
    }()
}

public final class USRealmManager: USRealmManagerType {

    private lazy var concurrentQueue = DispatchQueue.global(qos: .default)
    private var isRealmFileDeleted = Atomic<Bool>(false)

    private lazy var notificationQueue: DispatchQueue = {
        let queueLabel = "realm.notification.queue." + String(ObjectIdentifier(self).hashValue)
        let queue = DispatchQueue(label: queueLabel, qos: .default)
        return queue
    }()

    private lazy var configuration: Realm.Configuration = {
        var realmConfiguration = configurationBuilder()
        realmConfiguration.schemaVersion = USRealmManager.buildNumber
        #if DEBUG
        realmConfiguration.encryptionKey = nil
        #endif

        return realmConfiguration
    }()

    private let configurationBuilder: () -> Realm.Configuration

    public init(configuration: @autoclosure @escaping () -> Realm.Configuration) {
        self.configurationBuilder = configuration
    }

    public func object<T: Object, KeyType>(_ type: T.Type, forPrimaryKey: KeyType) -> T? {
        return workerRealm().object(ofType: type, forPrimaryKey: forPrimaryKey)
    }

    public func object<T: Object>(_ type: T.Type, id: T.Identity) -> T? where T: IdentifiableObject {
        return workerRealm().object(ofType: type, forPrimaryKey: id)
    }

    public func object<T: Object>(_ type: T.Type, filter predicate: NSPredicate) -> T? {
        return workerRealm().objects(type).first { predicate.evaluate(with: $0) }
    }

    public func objects<T: Object>(_ type: T.Type) -> Results<T> {
        return workerRealm().objects(type)
    }

    public func objects<T: Object>(_ type: T.Type, filter predicate: NSPredicate) -> Results<T> {
        return workerRealm().objects(type).filter(predicate)
    }

    public func observableObject<T: Object>(_ type: T.Type, id: T.Identity) -> Observable<T> where T: IdentifiableObject {
        return observableObjects(type)
            .map { $0.first(where: { $0.id == id }) }
            .filterNil()
    }

    public func observableObjects<T: Object>(_ type: T.Type) -> Observable<Results<T>> {
        return observableObjects(type, filter: NSPredicate(value: true))
    }

    public func observableObjects<T: Object>(_ type: T.Type, filter predicate: NSPredicate) -> Observable<Results<T>> {

        let observeQueue: DispatchQueue = notificationQueue

        return createAsyncRealm(queue: observeQueue)
            .flatMap { realm -> Observable<Results<T>> in
                Observable.collection(from: realm.objects(type).filter(predicate), on: observeQueue).map { $0.freeze() }
            }
            .observe(on: MainScheduler.instance)
    }

    public func asyncCreate(objects: [Object], update: Bool, completion: (() -> Void)?) {
        guard objects.isNotEmpty else { return }

        let freezeObjects = frozenObjects(from: objects)

        let block: (Realm) -> Void = { realm in
            realm.add(freezeObjects, update: update ? .all : .error)
            completion?()
        }
        asyncWrite(block)
    }

    public func create<T: Object>(_ type: T.Type, value: Any, update: Bool = false) {
        let block: (Realm) -> Void = { realm in
            _ = realm.create(type, value: value, update: update ? .all : .error)
        }
        asyncWrite(block)
    }

    public func delete<T: RealmSwift.Object>(object: T) {
        delete(items: [object])
    }

    public func delete<T: Object>(objects: RealmSwift.Results<T>) {
        delete(items: objects.toArray())
    }

    public func delete<T: Object>(list objects: RealmSwift.List<T>) {
        delete(items: objects.toArray())
    }

    public func delete<T>(type: T.Type) where T: Object {
        let block: (Realm) -> Void = { realm in
            let objects = realm.objects(type)
            realm.delete(objects)
        }
        asyncWrite(block)
    }

    public func delete<T: Object>(array: [T]) {
        self.delete(items: array)
    }

    public func clearData() {
        let block: (Realm) -> Void = { realm in
            realm.deleteAll()
        }

        asyncWrite(block)
    }

    private func frozenObjects<T: Object>(from items: [T]) -> [T] {
        let frozenObjects = items.map { object -> T in
            object.unmanaged()
        }
        return frozenObjects
    }
}

extension USRealmManager {

    func delete<T>(items: [T]) where T: Object {
        guard items.isNotEmpty else { return }

        let freezeObjects = frozenObjects(from: items)

        let block: (Realm) -> Void = { realm in
            let objects = freezeObjects.compactMap { object -> Object? in
                let objectType = type(of: object)
                guard let primaryKey = objectType.primaryKey() else {
                    return nil
                }
                let managedObject = realm.object(ofType: objectType, forPrimaryKey: object.value(forKey: primaryKey))
                return managedObject
            }
            realm.delete(objects)
        }

        asyncWrite(block)
    }

    func asyncWrite(_ block: @escaping (Realm) -> Void) {
        concurrentQueue.async {
            do {
                let realm = self.workerRealm()
                if realm.isInWriteTransaction {
                    block(realm)
                } else {
                    try realm.write { block(realm) }
                }
            } catch {
                
            }
        }
    }

    func syncWrite<T: Object>(ref: ThreadSafeReference<T>, write: @escaping ((T) throws -> Void)) {
        concurrentQueue.async {
            do {
                let realm = self.workerRealm()
                guard let object = realm.resolve(ref) else { return }

                if realm.isInWriteTransaction {
                    try write(object)
                } else {
                    try realm.write { try write(object) }
                }
            } catch {
                
            }
        }
    }
}

extension USRealmManager {

    func workerRealm() -> Realm {
        do {
            return try createRealm(configuration: configuration)
        } catch {
         
            fatalError(String(describing: error))
        }
    }

    func createAsyncRealm(queue: DispatchQueue) -> Observable<Realm> {

        let config = self.configuration
        return Observable<Realm>.create { observer -> Disposable in
            Realm.asyncOpen(configuration: config, callbackQueue: queue) { realm in
                
                switch realm {
                case .success(let realmData):
                    observer.onNext(realmData)
                    observer.onCompleted()
                    
                case .failure(let error):
                    
                    observer.onError(error)
                    #if DEBUG
                    print("Realm asyncOpen error: \(error)")
                    #endif
                }
            }
            return Disposables.create {}
        }
        .retry(.delayed(maxCount: 3, time: 2))
        .observe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
}

private extension USRealmManager {

    func createRealm(configuration: Realm.Configuration) throws -> Realm {
        do {
            return try Realm(configuration: configuration)
        } catch let error as NSError {
            #if DEBUG
            print("Realm createRealm error \(error), configuration: \(configuration)")
            #endif
          
            deleteRealm(for: configuration)
            return try Realm(configuration: configuration)
        }
    }

    func deleteRealm(for configuration: Realm.Configuration) {
        do {
            guard self.isRealmFileDeleted.value == false else { return }
            _ = try Realm.deleteFiles(for: configuration)
            self.isRealmFileDeleted.mutate { $0 = true }
        } catch {
            
        }
    }
}

class UnmanagedSession {
    let identifier = UUID()
    var data: [Int: Unmanagedable] = [:]
    func unmanagedObject<T: Unmanagedable>(for object: T) -> T? {
        return data[object.identifier] as? T
    }

    func add(object: Unmanagedable, identifier: Int) {
        data[identifier] = object
    }
}

protocol Unmanagedable: AnyObject {
    var identifier: Int { get }
    func unmanaged(session: UnmanagedSession) -> Self
}

extension Object: Unmanagedable {
    var identifier: Int {
        return hashValue
    }

    public func unmanaged() -> Self {
        let session = UnmanagedSession()
        return unmanaged(session: session)
    }

    func unmanaged(session: UnmanagedSession) -> Self {
        if let result = session.unmanagedObject(for: self) {
            return result
        }

        let unmanaged = type(of: self).init()
        session.add(object: unmanaged, identifier: identifier)
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }
            if let unmanagedable = value as? Unmanagedable {
                unmanaged.setValue(unmanagedable.unmanaged(session: session), forKey: property.name)
            } else {
                unmanaged.setValue(value, forKey: property.name)
            }
        }
        return unmanaged
    }
}

extension List: Unmanagedable where Element: Unmanagedable {
    var identifier: Int {
        return Int(arc4random_uniform(6) + 1)
    }

    func unmanaged(session: UnmanagedSession) -> Self {
        if let ret = session.unmanagedObject(for: self) {
            return ret
        }
        let result = type(of: self).init()
        session.add(object: result, identifier: identifier)
        let list = toArray().map { $0.unmanaged(session: session) }
        result.append(objectsIn: list)
        return result
    }
}

//
//  ViewControllerLifecycleObservable.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//

import Foundation
import RxCocoa
import RxSwift

public protocol ViewControllerLifecycleTrackable {
    var viewDidAppearSignal: Observable<String> { get }
}

public extension ViewControllerLifecycleTrackable where Self: UIViewController {
    var viewDidAppearSignal: Observable<String> {
        let className = String(describing: type(of: self))
        return rx.viewDidAppear.map { className }
    }
}

public protocol ViewControllerLifecycleObservable {
    var viewDidLoad: Observable<Void> { get }
    var viewWillAppear: Observable<Void> { get }
    var viewDidAppear: Observable<Void> { get }
    var viewWillDisappear: Observable<Void> { get }
    var viewDidDisappear: Observable<Void> { get }
}

public extension ViewControllerLifecycleObservable where Self: UIViewController {
    var viewDidLoad: Observable<Void> {
        return rx.viewDidLoad
    }

    var viewWillAppear: Observable<Void> {
        return rx.viewWillAppear
    }

    var viewDidAppear: Observable<Void> {
        return rx.viewDidAppear
    }

    var viewDidDisappear: Observable<Void> {
        return rx.viewDidDisappear
    }

    var viewWillDisappear: Observable<Void> {
        return rx.viewWillDisappear
    }
}

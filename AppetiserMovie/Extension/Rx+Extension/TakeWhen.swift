//
//  TakeWhen.swift
//  Upscale
//
//  Created by Duc Nguyen on 11/14/21.
//

import Foundation
import RxCocoa
import RxSwift

public extension ObservableType {
    
    /// Returns the latest element from the source observable sequence until the other observable sequence produces `true` element.
    ///
    /// - note: Only the latest value from this observable is emitted
    ///
    /// - parameter other: Observable sequence that filter elements of the source sequence.
    /// - returns: An observable sequence containing the elements of the source sequence
    
    func takeLatestWhen(_ other: Observable<Bool>) -> Observable<Element> {
        return Observable
            .combineLatest(other, self) { ($0, $1) }
            .filter { other, _ in return other }
            .map { _, value in return value }
    }
}

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    /// Returns the latest element from the source observable sequence until the other observable sequence produces `true` element.
    ///
    /// - note: Only the latest value from this observable is emitted
    ///
    /// - parameter other: Observable sequence that filter elements of the source sequence.
    /// - returns: An observable sequence containing the elements of the source sequence
    
    func takeLatestWhen(_ other: Driver<Bool>) -> Driver<Element> {
        return Driver
            .combineLatest(other, self) { ($0, $1) }
            .filter { other, _ in return other }
            .map { _, value in return value }
    }
}

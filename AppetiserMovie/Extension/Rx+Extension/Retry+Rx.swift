//
//  Retry+Rx.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import Foundation
import RxSwift
import RxSwiftExt

public extension ObservableType {
    /**
     Repeats the source observable sequence using given behavior in case of an error or until it successfully terminated
     - parameter maxAttempt: Number of attempt
     - parameter shouldRetry: Custom optional closure for checking error (if returns true, repeat will be performed)
     - returns: Observable sequence that will be automatically repeat if error occurred
     */
    
    func retry(maxAttempt: UInt, shouldRetry: RetryPredicate? = nil) -> Observable<Element> {
        return retry(1, maxAttempt: maxAttempt, shouldRetry: shouldRetry)
    }
    
    /**
     Repeats the source observable sequence using given behavior in case of an error or until it successfully terminated
     - parameter currentAttempt: Number of current attempt
     - parameter maxAttempt: Number of attempt
     - parameter shouldRetry: Custom optional closure for checking error (if returns true, repeat will be performed)
     - returns: Observable sequence that will be automatically repeat if error occurred
     */
    
    func retry(_ currentAttempt: UInt, maxAttempt: UInt, shouldRetry: RetryPredicate? = nil)
        -> Observable<Element> {
            guard currentAttempt > 0 else { return Observable.empty() }
            
            // calculate conditions for bahavior
            
            return catchError { error -> Observable<Element> in
                // return error if exceeds maximum amount of retries
                guard maxAttempt >= currentAttempt else { return Observable.error(error) }
                
                if let shouldRetry = shouldRetry, !shouldRetry(error) {
                    // also return error if predicate says so
                    return Observable.error(error)
                }
                
                return self.retry(currentAttempt + 1, maxAttempt: maxAttempt, shouldRetry: shouldRetry)
            }
    }
}

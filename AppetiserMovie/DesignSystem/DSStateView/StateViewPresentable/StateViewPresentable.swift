//
//  StateViewPresentable.swift
//  Upscale
//
//  Created by Duckie N on 24/11/2021.
//

import UIKit
import StatefulViewController
import RxSwift
import RxCocoa

public protocol StateViewPresentable: AnyObject, BackingViewProvider {
    
    // MARK: Loading View
    
    /// Default using `LoadingStyle.view`
    func loadingStyle() -> LoadingStyle
    
    /// Required
    /// Return nil if you use LoadingStyle.progressHUD
    func loadingView() -> UIView?
    
    // MARK: Setup states using configurations
    
    /// Modify the default StateConfig
    func edit(config: StateConfig, for state: ViewState, error: Error?) -> StateConfig
    
    func configForErrorState(_ error: Error?) -> StateConfig
    
    // MARK: Custom States
    
    func state(from error: Error) -> ViewState
    
    // MARK: Properties
    var currentState: BehaviorRelay<ViewState> { get }
    
    // MARK: Transitions
    
    func setupInitialViewState(_ completion: (() -> Void)?)
    
    func startLoading(animated: Bool, completion: (() -> Void)?)
    func endLoading(animated: Bool, error: Error?, completion: (() -> Void)?)
    
    func transitionViewStates(loading: Bool, error: Error?, animated: Bool, completion: (() -> Void)?)
    
    /// Force transition to a specific state
    func transition(to state: ViewState, error: Error?, animated: Bool, completion: (() -> Void)?)
    
    // MARK: Content and error handling
    
    /// Return true if content is available in your controller.
    /// Required
    func hasContent() -> Bool
    
    /// This method is called if an error occurred, but `hasContent` returned true.
    /// You would typically display an unobstrusive error message that is easily dismissable
    /// for the user to continue browsing content.
    ///
    /// - parameter error:    The error that occurred
    func handleErrorWhenContentAvailable(_ error: Error)
}

//
//  StateViewPresentable+Extension.swift
//  Upscale
//
//  Created by Duckie N on 24/11/2021.
//

import UIKit
import StatefulViewController
import RxSwift
import RxCocoa

extension StateViewPresentable {
    
    public func loadingStyle() -> LoadingStyle {
        let view = loadingView() ?? UIView()
        return .view(view)
    }
    
    public func viewForState(_ state: ViewState, error: Error?) -> UIView? { nil }
    
    public func set(view: UIView, for state: ViewState) {
        stateMachine[state.value] = view
    }
    
    public func state(from error: Error) -> ViewState { .error }
    public func edit(config: StateConfig, for state: ViewState, error: Error? = nil) -> StateConfig { config }
    public func configForErrorState(_ error: Error?) -> StateConfig {
        
//        if !Reachability.isConnectedNetwork() {
//            return StateConfig(image: Assets.icNoInternet.image,
//                               title: L10n.commonNoNetworkStateTitle.key.localized(),
//                               message: L10n.errorCommonNoInternetConnection.key.localized(),
//                               actionTitle: nil)
//        }
//
//        if (error as? NSError)?.description.contains("Code=403") ?? false {
//            return StateConfig(image: Assets.icAlertTriangle.image,
//                               title: L10n.commonNoPermissionTitle.key.localized(),
//                               message: L10n.commonNoPermissionDesciption.key.localized(),
//                               actionTitle: nil)
//        }
        
        return .error
        
    }
}

// MARK: Properties

extension StateViewPresentable {
    
    private var stateMachine: ViewStateMachine {
        return associatedObject(self, key: &stateMachineKey) { [unowned self] in
            return ViewStateMachine(view: self.backingView)
        }
    }
    
    private var data: AssociatedObject {
        return associatedObject(self, key: &dataKey) { AssociatedObject() }
    }
    
    public var currentState: BehaviorRelay<ViewState> { return data.currentState }
}

// MARK: Transitions

extension StateViewPresentable {
    
    public func setupInitialViewState(_ completion: (() -> Void)? = nil) {
        let isLoading = (lastState == .loading)
        let error: Error? = (lastState == .error) ? data.error : nil
        transitionViewStates(loading: isLoading, error: error, animated: false, completion: completion)
    }
    
    private var lastState: ViewState {
        switch stateMachine.lastState {
        case .none: return .content
        case .view(let viewKey): return ViewState(value: viewKey)
        }
    }
    
    public func startLoading(animated: Bool = false, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.transitionViewStates(loading: true, animated: animated, completion: completion)
        }
    }
    
    public func endLoading(animated: Bool = true, error: Error? = nil, completion: (() -> Void)? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            self?.transitionViewStates(loading: false, error: error, animated: animated, completion: completion)
        }
    }
    
    public func transitionViewStates(loading: Bool = false, error: Error? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        // Update view for content (i.e. hide all placeholder views)
        let loadingStyle: LoadingStyle
        if let loadingView = stateMachine[ViewState.loading.value] {
            loadingStyle = LoadingStyle.view(loadingView)
        } else {
            loadingStyle = self.loadingStyle()
            prepareLoading(style: loadingStyle, isLoading: loading)
        }
        if hasContent() {
            if let error = error {
                // show unobstrusive error
                handleErrorWhenContentAvailable(error)
            }
            transition(to: .content, error: error, animated: animated, completion: completion)
            return
        }
        
        // Update view for placeholder
        var newState: ViewState = .empty
        if loading {
            if loadingStyle.isProgressHUD {
                newState = .content
            } else {
                newState = .loading
            }
        } else if let error = error {
            newState = state(from: error)
        }
        transition(to: newState, error: error, animated: animated, completion: completion)
    }
    
    private func prepareLoading(style: LoadingStyle, isLoading: Bool) {
        switch style {
        case .view(let view):
            stateMachine[ViewState.loading.value] = view
        default:
            break
        }
    }
    
    public func transition(to state: ViewState, error: Error? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        data.error = error
        prepareView(for: state, error: error)
        if state == .content {
            stateMachine.transitionToState(.none, animated: animated, completion: completion)
        } else {
            stateMachine.transitionToState(.view(state.value), animated: animated, completion: completion)
        }
        currentState.accept(state)
    }
    
    private func prepareView(for state: ViewState, error: Error?) {
        /// Check cached views
        var stateView: UIView? = stateMachine[state.value]
        /// If view isn't cached yet, get from custom view
        if stateView == nil {
            stateView = viewForState(state, error: error) ?? defaultViewForState(state, error: error)
            stateMachine[state.value] = stateView
        }
        guard let dsStateView = stateView as? DSStateView else { return }
        guard let config = configForState(state, error: error)  else { return }
        dsStateView.update(with: config)
    }
    
    private func configForState(_ state: ViewState, error: Error?) -> StateConfig? {
        switch state {
        case .content:
            return nil
        case .loading:
            return nil
        case .error:
            let errorConfig = configForErrorState(error)
            return edit(config: errorConfig, for: .error, error: error)
        case .empty:
            return edit(config: .empty, for: .empty, error: error)
        case .forceUpdate:
            return edit(config: .forceUpdate, for: .forceUpdate, error: error)
        case .maintenance:
            return edit(config: .maintenance, for: .maintenance, error: error)
        case .notFound:
            return edit(config: .notFound, for: .notFound, error: error)
        default:
            return edit(config: StateConfig(), for: state, error: error)
        }
    }
    
    private func defaultViewForState(_ state: ViewState, error: Error?) -> UIView? {
        switch state {
        case .content:
            return nil
        case .loading:
            return loadingView()
        case .error:
            return DSErrorStateView()
        default:
            return DSStateView()
        }
    }
    
    // MARK: Content and error handling
    
    public func handleErrorWhenContentAvailable(_ error: Error) {
        // Default implementation does nothing.
    }
}

private class AssociatedObject {
    
    var currentState = BehaviorRelay<ViewState>(value: .content)
    var error: Error?
    
    init() {}
}

// MARK: Association

private var stateMachineKey: UInt8 = 0
private var dataKey: UInt8 = 1

private func associatedObject<T: AnyObject>(_ host: AnyObject, key: UnsafeRawPointer, initial: () -> T) -> T {
    var value = objc_getAssociatedObject(host, key) as? T
    if value == nil {
        value = initial()
        objc_setAssociatedObject(host, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
    // swiftlint:disable force_unwrapping
    return value!
}

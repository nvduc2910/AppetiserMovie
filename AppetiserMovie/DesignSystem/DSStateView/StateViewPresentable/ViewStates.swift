//
//  ExtendedStates.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import Foundation

public struct ViewState: Equatable {
    
    public let value: String
    
    public static let content = ViewState(value: "content")
    public static let loading = ViewState(value: "loading")
    public static let empty = ViewState(value: "empty")
    public static let error = ViewState(value: "error")
}

public extension ViewState {
    
    static let forceUpdate = ViewState(value: "forceUpdate")
    static let maintenance = ViewState(value: "maintenance")
    static let permission = ViewState(value: "permission")
    static let notFound = ViewState(value: "notFound")
}

//
//  DefaultStateConfigs.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import UIKit

extension StateConfig {
    
    public static let error = StateConfig(image: Assets.notFound.image,
                                          title: "Services are temporarily unavailable.",
                                          message: L10n.errorCommonUnavailable,
                                          actionTitle: nil)
    
    public static let noInternetError = StateConfig(image: Assets.notFound.image,
                                                    title: "Unavailable due to network issue",
                                                    message: "No Internet connection found. Check your connection",
                                                    actionTitle: "Retry")
    
    public static let empty = StateConfig(image: Assets.notFound.image.withTintColor(Colors.neutral),
                                          title: L10n.commonEmptyStateTitle,
                                          message: L10n.commonEmptyStateDes,
                                          actionTitle: nil)
    
    public static let forceUpdate = StateConfig(image: Assets.notFound.image,
                                                title: L10n.commonForceUpdateStateTitle,
                                                message: L10n.commonForceUpdateStateDes,
                                                actionTitle: "OK") {
        guard let url = URL(string: "") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil) }
    
    public static let maintenance = StateConfig(image: Assets.notFound.image,
                                                title: "Maintainance",
                                                message: "The system under maintainance. Please comback later.",
                                                actionTitle: "Got it")
    
    static let notFound = StateConfig(image: Assets.notFound.image,
                                      title: "Not found",
                                      message: "Data not found",
                                      actionTitle: "Got it")
}

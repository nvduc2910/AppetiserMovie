//
//  TabbarItem.swift
//  AppetiserMovie
//
//  Created by ZVN20210023 on 23/02/2023.
//

import Foundation
import UIKit

struct TabBarItem {
    let title: String
    let image: String
    let associatedCoordinatorAndController: (BaseCoordinator, UIViewController)
    var associatedController: UIViewController { associatedCoordinatorAndController.1 }

    init(title: String,
         image: String,
         associatedCoordinatorAndController: (BaseCoordinator, UIViewController))
    {
        self.title = title
        self.image = image
        self.associatedCoordinatorAndController = associatedCoordinatorAndController
    }
}

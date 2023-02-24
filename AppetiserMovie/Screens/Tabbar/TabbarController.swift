//
//  TabbarController.swift
//  AppetiserMovie
//
//  Created by ZVN20210023 on 23/02/2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TabBarController {
    private static func makeTabBarItems() -> [TabBarItem] {
        return []
//        return [
//            TabBarItem(
//                title: "",
//                image: "",
//                associatedCoordinatorAndController: AppCoordinator.shared.startHomeView()
//            ),
//            TabBarItem(
//                title: "",
//                image: "",
//                associatedCoordinatorAndController: AppCoordinator.shared.startFavoriteView()
//            )
//        ]
    }
}

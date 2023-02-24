//
//  FavoritedMovieViewController.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import UIKit

class FavoritedMovieViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        tabBarItem = UITabBarItem(title: "Favorite",
                                  image: Assets.icFavoriteTabbar.image,
                                  tag: 0)
        tabBarItem.selectedImage = Assets.icFavoriteTabbarSelected.image
    }
}

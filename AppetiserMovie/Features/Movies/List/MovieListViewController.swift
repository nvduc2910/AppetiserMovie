//
//  MovieListViewController.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import UIKit

class MovieListViewController: BaseViewController {
    
    // MARK: - outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        
        view.backgroundColor = Colors.primary
        tableView.isHidden = true
        headerView.backgroundColor = Colors.primary
        titleLabel.setStyle(DS.mobileHero(color: Colors.white))
        titleLabel.text = "Movie"
        
        searchButton.setTitle("", for: .normal)
        searchButton.setImage(Assets.icSearch.image, for: .normal)
        searchButton.tintColor = Colors.white
        
        tabBarItem = UITabBarItem(title: "Home",
                                  image: Assets.icHomeTabbar.image,
                                  tag: 0)
        tabBarItem.selectedImage = Assets.icHomeTabbarSelected.image
    }
}

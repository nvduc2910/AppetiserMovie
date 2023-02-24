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
        tableView.backgroundColor = Colors.primary
        headerView.backgroundColor = Colors.primary
        titleLabel.setStyle(DS.mobileHero(color: Colors.white))
        titleLabel.text = "Movie"
        
        searchButton.setTitle("", for: .normal)
        searchButton.setImage(Assets.icSearch.image, for: .normal)
        searchButton.tintColor = Colors.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: MovieItemTableViewCell.self)
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MovieItemTableViewCell.self)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}

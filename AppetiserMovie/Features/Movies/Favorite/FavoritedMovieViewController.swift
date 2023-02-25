//
//  FavoritedMovieViewController.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import UIKit

class FavoritedMovieViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: FavoriteListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTabbar()
        bind(to: viewModel)
        
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureView() {
        
        view.backgroundColor = Colors.primary
        tableView.backgroundColor = Colors.primary
        headerView.backgroundColor = Colors.primary
        titleLabel.setStyle(DS.mobileHero(color: Colors.white))
        titleLabel.text = L10n.titleScreenFavorite
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: MovieItemTableViewCell.self)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    
    func configureTabbar() {
        tabBarItem = UITabBarItem(title: L10n.titleScreenFavorite,
                                  image: Assets.icFavoriteTabbar.image,
                                  tag: 0)
        tabBarItem.selectedImage = Assets.icFavoriteTabbarSelected.image
    }
    
    func bind(to viewModel: FavoriteListViewModel) {
        viewModel
            .itemsRelay
            .asDriver()
            .driveNext { [weak self] items in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}


extension FavoritedMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MovieItemTableViewCell.self)
        let model = viewModel.itemsRelay.value[indexPath.row]
        cell.configureData(model)
        cell.favoriteButton.rx.tap.subscribeNext { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.input.removeFavoriteTrigger.accept(model)
        }.disposed(by: cell.disposeBag)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didTapItem.accept(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}

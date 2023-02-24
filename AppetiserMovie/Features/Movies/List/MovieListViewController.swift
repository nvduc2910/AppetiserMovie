//
//  MovieListViewController.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import UIKit

class MovieListViewController: BaseViewController, MVVMView {
    
    // MARK: - outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var viewModel: MovieListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind(to: viewModel)
        
        viewModel.viewDidLoad()
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
    
    func bind(to viewModel: MovieListViewModel) {
        viewModel
            .output
            .isLoadingStream
            .subscribeNext { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.startLoading()
                } else {
                    self.endLoading(animated: true, error: nil, completion: nil)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsRelay.value.count
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

extension MovieListViewController: StateViewPresentable {
    var backingView: UIView {
        return containerView
    }
    
    private func makeSkeletionView() -> SkeletonTableView {
        
        let configureCell: SkeletonTableView.ConfigureCell = { [weak self] (tableView, indexPath) -> UITableViewCell in
            let cell: MovieItemLoadingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.selectionStyle = .none
            guard self != nil else {
                return cell
            }
            return cell
        }
        
        let configureTableView: SkeletonTableView.ConfigureTableView = { tableView in
            tableView.register(cellType: MovieItemLoadingTableViewCell.self)
            tableView.rowHeight = 145
            tableView.backgroundColor = .clear
        }
        
        let skeletonView = SkeletonTableView(configureCell: configureCell, configureTableView: configureTableView)
        skeletonView.backgroundColor = .clear
        return skeletonView
    }
    
    func loadingView() -> UIView? {
        return makeSkeletionView()
    }
    
    func hasContent() -> Bool {
        viewModel.output.itemsStream.value.isNotEmpty
    }
}

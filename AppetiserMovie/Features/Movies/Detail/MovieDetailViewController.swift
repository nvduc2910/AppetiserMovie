//
//  MovieDetailViewController.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import UIKit

class MovieDetailViewController: BaseViewController, MVVMView {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MovieDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.register(cellType: MovieSummaryTableViewCell.self)
        tableView.register(cellType: MovieDescriptionTableViewCell.self)
    }
    
    func bind(to viewModel: MovieDetailViewModel) {
        viewModel
            .output
            .movieSection
            .asDriver()
            .driveNext { [weak self] sections in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieSection.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.movieSection.value[indexPath.row]
        switch model {
        case .summary(let data):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MovieSummaryTableViewCell.self)
            
            cell.backButton.rx.tap.subscribeNext { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: cell.disposeBag)
            
            cell.favoriteButton.rx.tap.subscribeNext { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.favoriteTrigger.accept(data)
            }.disposed(by: cell.disposeBag)
            
            cell.selectionStyle = .none
            cell.configureData(data)
            return cell
        case .description(let string):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MovieDescriptionTableViewCell.self)
            cell.selectionStyle = .none
            cell.configureData(string)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//
//  SearchViewController.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController, MVVMView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchBoxView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    var viewModel: MovieListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        bind(to: viewModel)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureView() {
        headerView.backgroundColor = Colors.primary
        
        searchBoxView.backgroundColor = Colors.secondary
        searchBoxView.cornerRadius = 6
        
        textField.setStyle(DS.pDefault(color: Colors.white))
        textField.placeholder = L10n.commonTypeToSearch
        view.backgroundColor = Colors.primary
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: MovieItemTableViewCell.self)
        
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(Assets.icBack.image, for: .normal)
        closeButton.tintColor = Colors.white
        closeButton.rx.tap.subscribeNext { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        textField.becomeFirstResponder()
        textField
            .rx
            .text
            .distinctUntilChanged()
            .skip(1)
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribeNext { [weak self] text in
                guard let self = self else { return }
                self.viewModel.searchTrigger.accept(text.orEmpty)
                
            }.disposed(by: disposeBag)
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
        
        viewModel
            .errorPublish
            .subscribeNext { [weak self] error in
                guard let self = self else { return }
                self.endLoading(animated: true, error: error, completion: nil)
            }
            .disposed(by: disposeBag)
        
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
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
            self.viewModel.input.favoriteTrigger.accept(model)
        }.disposed(by: cell.disposeBag)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}


extension SearchViewController: StateViewPresentable {
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

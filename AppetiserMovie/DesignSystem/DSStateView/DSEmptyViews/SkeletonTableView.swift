//
//  SkeletonTableView.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import Foundation
import Reusable
import SkeletonView
import StatefulViewController
import UIKit

public class SkeletonBaseView: UIView, StatefulPlaceholderView {
    
    public func showLoading(_: Bool) {}
    public var viewInsets: UIEdgeInsets = UIEdgeInsets.zero

    public func placeholderViewInsets() -> UIEdgeInsets {
        return viewInsets
    }
}

public class SkeletonTableView: SkeletonBaseView {
    private(set) lazy var tableView: UITableView = UITableView()

    public typealias ConfigureTableView = (UITableView) -> Void
    public typealias ConfigureCell = (UITableView, IndexPath) -> UITableViewCell

    private(set) var configureCell: ConfigureCell
    private(set) var isActiveSkeleton: Bool = true
    
    var numberOfRow: Int

    public init(configureCell: @escaping ConfigureCell,
                configureTableView: ConfigureTableView? = nil,
                numberOfRow: Int = 20) {
        self.numberOfRow = numberOfRow
        self.configureCell = configureCell
        super.init(frame: .zero)
        setupView()
        configureView()
        configureTableView?(tableView)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(tableView)
    }

    private func configureView() {
        backgroundColor = Colors.neutral

        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }

        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 160
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.dataSource = self
    }

    override public func showLoading(_ isLoading: Bool) {
        isActiveSkeleton = isLoading
        tableView.reloadData()
    }
}

extension SkeletonTableView: UITableViewDataSource {

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return numberOfRow
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(tableView, indexPath)

        cell.contentView.isHidden = !isActiveSkeleton

        if isActiveSkeleton {
            cell.showSkeleton(usingColor: .darkGray)
        } else {
            cell.hideSkeleton()
        }
        return cell
    }
}

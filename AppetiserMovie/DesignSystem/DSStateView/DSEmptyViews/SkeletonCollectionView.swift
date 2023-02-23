//
//  SkeletonCollectionView.swift
//  Upscale
//
//  Created by Duckie N on 24/11/2021.
//

import Reusable
import SkeletonView
import UIKit

public class SkeletonCollectionView: SkeletonBaseView {

    public let collectionView: UICollectionView

    public typealias ConfigureCollectionView = (UICollectionView) -> Void
    public typealias ConfigureCell = (UICollectionView, IndexPath) -> UICollectionViewCell

    private(set) var configureCell: ConfigureCell
    private(set) var isActiveSkeleton: Bool = true

    public init(configureCell: @escaping ConfigureCell,
                configureCollectionView: ConfigureCollectionView? = nil,
                itemSize: CGSize,
                contentInset: UIEdgeInsets = .zero,
                scrollDirection: UICollectionView.ScrollDirection = .horizontal) {
        
        self.configureCell = configureCell

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.scrollDirection = scrollDirection
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.contentInset = contentInset

        super.init(frame: .zero)
        setupView()
        configureView()
        configureCollectionView?(collectionView)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(collectionView)
    }

    private func configureView() {
        backgroundColor = .white

        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
    }

    override public func showLoading(_ isLoading: Bool) {
        isActiveSkeleton = isLoading
        collectionView.reloadData()
        collectionView.invalidateIntrinsicContentSize()
    }
}

extension SkeletonCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 8
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = configureCell(collectionView, indexPath)

        if isActiveSkeleton {
            cell.showAnimatedGradientSkeleton()
        } else {
            cell.hideSkeleton()
        }
        return cell
    }
}

extension SkeletonCollectionView {
    public func updateMinimumInteritemSpacing(_ spacing: CGFloat) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = spacing
            layout.invalidateLayout()
            collectionView.reloadData()
        }
    }
}

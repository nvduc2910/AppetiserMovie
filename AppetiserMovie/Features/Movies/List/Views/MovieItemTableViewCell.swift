//
//  MovieItemTableViewCell.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import UIKit
import RxSwift
import Reusable

class MovieItemTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var boundView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configureView() {
        boundView.cornerRadius = 6
        boundView.backgroundColor = Colors.secondary
        thumbnailImageView.cornerRadius = 6
        thumbnailImageView.contentMode = .scaleAspectFill
        titleLabel.setStyle(DS.mobileH1(color: Colors.white))
        descriptionLabel.setStyle(DS.pDefault(color: Colors.neutral))
        priceLabel.setStyle(DS.pDefault(color: Colors.neutral100))
    }
    
    func configureData(_ data: MovieItemUIModel) {
        titleLabel.text = data.trackName
        data.isFavorite ? favoriteButton.setImage(Assets.icFavorite24.image, for: .normal) : favoriteButton.setImage(Assets.icUnfavorite24.image, for: .normal)
        descriptionLabel.text = data.shortDescription.orEmpty
        priceLabel.text = "\(data.trackPrice ?? 0)\(data.currency.orEmpty) | \(data.genreName ?? "")"
        let artworkURLString = data.artworkUrl?.absoluteString.replacingOccurrences(of: "100x100", with: "500x500")
        thumbnailImageView.setImageURL(URL(string: artworkURLString.orEmpty), placeholder: Assets.placeholderImage.image)
    }
}

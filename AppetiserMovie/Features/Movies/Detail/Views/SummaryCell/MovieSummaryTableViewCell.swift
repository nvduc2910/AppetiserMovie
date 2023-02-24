//
//  MovieSummaryTableViewCell.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import UIKit
import Reusable
import RxSwift

class MovieSummaryTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
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
        backButton.setTitle("", for: .normal)
        backButton.setImage(Assets.icBack.image, for: .normal)
        backButton.tintColor = Colors.white
        
        favoriteButton.setTitle("", for: .normal)
        titleLabel.setStyle(DS.mobileHero(color: Colors.white))
        
        priceLabel.setStyle(DS.pDefault(color: Colors.white))
        thumbnailImage.cornerRadius = 6
    }
    
    func configureData(_ data: MovieItemUIModel) {
        titleLabel.text = data.trackName
        data.isFavorite ? favoriteButton.setImage(Assets.icFavorite24.image, for: .normal) : favoriteButton.setImage(Assets.icUnfavorite24.image, for: .normal)
        priceLabel.text = "\(data.trackPrice ?? 0)\(data.currency.orEmpty)"
        let artworkURLString = data.artworkUrl?.absoluteString.replacingOccurrences(of: "100x100", with: "500x500")
        thumbnailImage.setImageURL(URL(string: artworkURLString.orEmpty), placeholder: Assets.placeholderImage.image)
    }
}

//
//  MovieDescriptionTableViewCell.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import UIKit
import Reusable

class MovieDescriptionTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureView() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.setStyle(DS.pDefault(color: Colors.white))
    }
    
    func configureData(_ data: String) {
        descriptionLabel.text = data
    }
    
}

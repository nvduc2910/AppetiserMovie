//
//  MovieItemLoadingTableViewCell.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import UIKit
import Reusable

class MovieItemLoadingTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var boundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        boundView.layer.cornerRadius = 8
        boundView.layer.masksToBounds = false
        self.layoutIfNeeded()
    }
}

//
//  MovieCell.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

import UIKit

class MovieCell: UITableViewCell {
    static let reuseIdentifier = "MovieCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    func setup(with model: Movie) {
        nameLabel.text = model.title
        dateLable.text = model.date
        detailsLabel.text = model.info
    }
}

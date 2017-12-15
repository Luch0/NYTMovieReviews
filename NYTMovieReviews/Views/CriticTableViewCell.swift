//
//  CriticTableViewCell.swift
//  NYTMovieReviews
//
//  Created by Luis Calle on 12/14/17.
//  Copyright © 2017 Luis Calle. All rights reserved.
//

import UIKit

class CriticTableViewCell: UITableViewCell {

    @IBOutlet weak var criticImage: UIImageView!
    @IBOutlet weak var criticNameLabel: UILabel!
    @IBOutlet weak var imageSpinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

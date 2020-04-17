//
//  MovieTableViewCell.swift
//  MovieChecker
//
//  Created by user169883 on 4/17/20.
//  Copyright © 2020 user169883. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {


    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

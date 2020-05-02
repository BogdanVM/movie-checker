//
//  TVShowsTableViewCell.swift
//  MovieChecker
//
//  Created by user169883 on 5/1/20.
//  Copyright © 2020 user169883. All rights reserved.
//

import UIKit

class TVShowsTableViewCell: UITableViewCell {

    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

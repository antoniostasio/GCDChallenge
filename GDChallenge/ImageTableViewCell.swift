//
//  ImageTableViewCell.swift
//  GDChallenge
//
//  Created by Antonio Stasio on 16/03/2017.
//  Copyright © 2017 Antonio Stasio. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

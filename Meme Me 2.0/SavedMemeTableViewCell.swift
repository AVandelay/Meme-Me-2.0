//
//  SavedMemeTableViewCell.swift
//  Meme Me 2.0
//
//  Created by Ken Westdorp on 7/9/17.
//  Copyright © 2017 Ken Westdorp. All rights reserved.
//

import UIKit

class SavedMemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

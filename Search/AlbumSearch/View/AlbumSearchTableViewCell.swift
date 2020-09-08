//
//  AlbumSearchTableViewCell.swift
//  Search
//
//  Created by Subbu on 07/09/20.
//  Copyright © 2020 Subbu. All rights reserved.
//

import UIKit

class AlbumSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var tiltleLabel: UILabel!
    @IBOutlet weak var valueField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

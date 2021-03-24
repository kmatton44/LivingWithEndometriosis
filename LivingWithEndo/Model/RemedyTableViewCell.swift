//
//  RemedyTableViewCell.swift
//  LivingWithEndo
//
//  Created by MacBook on 3/16/21.
//  Copyright © 2021 Kanoa Matton. All rights reserved.
//

import UIKit

class RemedyTableViewCell: UITableViewCell {

    @IBOutlet weak var remedyTitle: UILabel!
    @IBOutlet weak var greenCheckImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

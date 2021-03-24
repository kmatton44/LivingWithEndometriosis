//
//  MessageTableViewCell.swift
//  LivingWithEndo
//
//  Created by MacBook on 3/22/21.
//  Copyright © 2021 Kanoa Matton. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageContentView: UIView!
    @IBOutlet weak var messageText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

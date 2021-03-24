//
//  RoundButton.swift
//  LivingWithEndo
//
//  Created by Kanoa Matton on 7/15/19.
//  Copyright © 2019 Kanoa Matton. All rights reserved.
//

import UIKit

@IBDesignable
class Round_Button: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}

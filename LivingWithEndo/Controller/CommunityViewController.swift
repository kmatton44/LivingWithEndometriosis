//
//  CommunityViewController.swift
//  LivingWithEndo
//
//  Created by MacBook on 3/19/21.
//  Copyright © 2021 Kanoa Matton. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {

    @IBOutlet weak var communityPhotoContentView: UIView!
    @IBOutlet weak var communityPhotoImage: UIImageView!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    func setUpUI() {
        communityPhotoContentView.layer.shadowRadius = 10
        communityPhotoContentView.layer.shadowOpacity = 0.6
        
        
    }
   

}

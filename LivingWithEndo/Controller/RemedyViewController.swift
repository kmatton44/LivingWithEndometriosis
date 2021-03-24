//
//  RemedyViewController.swift
//  LivingWithEndo
//
//  Created by MacBook on 3/17/21.
//  Copyright © 2021 Kanoa Matton. All rights reserved.
//

import UIKit

class RemedyViewController: UIViewController {
    
    @IBOutlet weak var remedyTitle: UILabel!
    @IBOutlet weak var remedyDescription: UILabel!
    @IBOutlet weak var remedyPicture: UIImageView!
    @IBOutlet weak var remedyPictureContentView: UIView!
    
    var remedy: Remedies?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        remedyTitle.text = remedy?.title
        remedyDescription.text = remedy?.description
        
        setUpUI()

        
        
    }
    
    func setUpUI() {
        
        remedyPictureContentView.layer.shadowRadius = 10
        remedyPictureContentView.layer.shadowOpacity = 0.6
        
        switch remedy?.title {
        case "Heat":
            remedyPicture.image = UIImage(named: "heatRemedy")
        case "OTC Anti-Flammatory Medicine":
            remedyPicture.image = UIImage(named: "antiFlammatoryRemedy")
        case "Castor Oil":
            remedyPicture.image = UIImage(named: "castorOilRemedy")
        case "Turmeric":
            remedyPicture.image = UIImage(named: "turmericRemedy")
        case "Choosing Anti-Flammatory Foods":
            remedyPicture.image = UIImage(named: "antiFlammatoryFoodRemedy")
        case "Pelvic Massages":
            remedyPicture.image = UIImage(named: "pelvicMassageRemedy")
        case "Ginger Tea":
            remedyPicture.image = UIImage(named: "gingerTeaRemedy")
        default:
            return
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

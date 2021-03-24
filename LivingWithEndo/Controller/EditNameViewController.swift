//
//  EditNameViewController.swift
//  LivingWithEndo
//
//  Created by MacBook on 3/16/21.
//  Copyright © 2021 Kanoa Matton. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftKeychainWrapper
import Firebase

class EditNameViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    var username: String?
    var usernameText: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else{return}
        
        if usernameTextField.text!.isEmpty {
            usernameText = "user53798573"
        }
        else {
            usernameText = (usernameTextField?.text)!
        }
        
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = usernameText
        changeRequest?.commitChanges { (error) in
        
        }
        
        username = usernameText
        
    }
    

}

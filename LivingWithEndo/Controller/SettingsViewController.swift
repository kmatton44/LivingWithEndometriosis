//
//  SettingsViewController.swift
//  LivingWithEndo
//
//  Created by Kanoa Matton on 9/3/19.
//  Copyright © 2019 Kanoa Matton. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

class SettingsViewController: UIViewController {
    
   
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var imageData: Data? = nil
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .userInitiated)
       
        
       
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
                if user != nil {
                    //There is a user
                    DispatchQueue.main.async {
                        self.usernameLabel.text = user?.displayName ?? "Edit Name"
                    }
                    
                    // Get the user profile picture from storage
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    let profilePicRef = storageRef.child("ProfileImages/\(Auth.auth().currentUser!.uid).jpg")
                    
                    
                    profilePicRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Error occured
                            return
                        }
                        // Now we set the image using the downloadURL
                        // To not lag the UI as we grab the data
                        DispatchQueue.global(qos: .userInitiated).async {
                            self.imageData = try! Data(contentsOf: downloadURL)
                            self.image = UIImage(data: self.imageData!)
                            
                            DispatchQueue.main.async {
                                self.profilePictureImageView.image = self.image
                            }
                        }
       
                    }
                    
                        
                } else {
                    //There is no user, go to sign in page
                    self.performSegue(withIdentifier: "toSignIn", sender: self)
                }
            
        }
        
        
        
            
        
        
        setUpUI()
    
    }
    
    func setUpUI() {
        
        profilePictureImageView.layer.cornerRadius = 40
        
    }
    
    
    
    
    
    @IBAction func logOut(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
    
}

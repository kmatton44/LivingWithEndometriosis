//
//  ViewController.swift
//  LivingWithEndo
//
//  Created by Kanoa Matton on 7/15/19.
//  Copyright © 2019 Kanoa Matton. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var letsGetStartedContentView: UIView!
    @IBOutlet weak var letsGetStartedLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var numberOfRemediesCompleted: Int = 0
    var remediesFinished: [String] = []
    
    var imageData: Data? = nil
    var image: UIImage?
    
    // MARK: VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // 1. Check for a user
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
                if user != nil {
                    //There is a user
                    self.displayName.text = user?.displayName ?? "Edit Name"
                    
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
                                self.profilePicture.image = self.image
                            }
                        }
       
                    }
                    
                    // 2. Set up user interface
                    self.setUpUserInterface()
                    
                    // 3. Reset daily remedies in UI and database based off latest date and today's date. If today's date is different than latest date stored, then reset.
                    self.resetDailyRemedies()
                    
                    // 4. Then we store latest date
                    self.getAndStoreLatestDate()
                    
                    
                    
                } else {
                    //There is no user, go to sign in page
                    self.performSegue(withIdentifier: "toSignIn", sender: self)
                }
             
            
            
        }
        
   
    }
    
  // MARK: FUNCTIONS
    func resetDailyRemedies() {
        let ref = Database.database().reference()
        let userUID = Auth.auth().currentUser?.uid
        // Grab latest date from user defaults
        let latestDate = defaults.string(forKey: "latestDate") ?? ""
        //Now get current date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let todaysDate = formatter.string(from: date)
        // Now compare the two, if different, reset remedies
        
        if todaysDate != latestDate {
            ref.child("Users/\(userUID!)/DailyRemedies").setValue(["0": "not done", "1": "not done", "2": "not done", "3": "not done", "4": "not done", "5": "not done", "6": "not done"])
        }
        
        
    }
    
    func getAndStoreLatestDate() {
        //Get Todays date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let todaysDate = formatter.string(from: date)
        
        // Store it in user defaults to compare it to future date
        defaults.set(todaysDate, forKey: "latestDate")
        
    }
    
    func setUpUserInterface() {
        let ref = Database.database().reference()
        let userUID = Auth.auth().currentUser?.uid
        profilePicture.layer.cornerRadius = 40
        letsGetStartedContentView.layer.cornerRadius = 10
        letsGetStartedContentView.layer.shadowRadius = 3
        letsGetStartedContentView.layer.shadowOpacity = 0.1
       
        ref.child("Users").child(userUID!).child("DailyRemedies").observeSingleEvent(of: DataEventType.value, with: { snapshot in
            if let remediesFinished = snapshot.value as? [String] {
                self.remediesFinished = remediesFinished
            } else {
                //
            }
        
        // Loop through that list to get number of finished remedies
        for n in self.remediesFinished {
            if n == "done" {
                self.numberOfRemediesCompleted += 1
            }
        }
        // Update the label
        let animation = {
            self.letsGetStartedLabel.text = self.numberOfRemediesCompleted == 0 ? "Let's Get Started!" : "\(self.numberOfRemediesCompleted) out of 7 remedies done!"
            
        }
        
            let animation2 = {
                self.activityIndicator.alpha = 0
            }
           
        UIView.transition(with: self.letsGetStartedLabel, duration: 0.5, options: .transitionCrossDissolve, animations: animation, completion: nil)
        
            UIView.transition(with: self.activityIndicator , duration: 0, options: .transitionCrossDissolve, animations: animation2, completion: nil)
        
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
           
            // Create storage reference
            let storage = Storage.storage()
            let storageRef = storage.reference()
            // Create reference to the file we want uploaded
            let profilePicRef = storageRef.child("ProfileImages/\(Auth.auth().currentUser!.uid).jpg")
            // Upload the file to that path ^
            let uploadTask = profilePicRef.putFile(from: imageURL, metadata: nil) { metadata, error in
                guard let metadata = metadata else {
                    // Error occured
                    return
                }
                //Metadata contains file metadata such as size, content-type
                //let size = metadata.size
                // We can also access to download URL after upload
                profilePicRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Error occured
                        return
                    }
                    // Now we set the image using the downloadURL
                    let imageData = try! Data(contentsOf: downloadURL)
                    let image = UIImage(data: imageData)
                    self.profilePicture.image = image
                    
                }
                
                
            }
            
            uploadTask.observe(.success) { (snapshot) in
                print("UPLOAD TASK COMPLETED")
                
            }
            
            
            
            
        } else {
            //Error message
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: IBACTIONS
    @IBAction func nameTapGesturePressed(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toEditName", sender: self)
    }
    
    @IBAction func photoTapGesturePressed(_ sender: UITapGestureRecognizer) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
            // After it is completed
        }
    }
    
    @IBAction func letsGetStartedTapGesturePresssed(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toLetsGetStarted", sender: self)
    }
    
    
    
    //MARK: UNWIND SEGUE
    
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
        
        guard (segue.identifier == "saveUnwind"), let sourceViewController = segue.source as? EditNameViewController else {return}
        
        guard segue.identifier == "saveUnwind", let username = sourceViewController.username else {return}
        
        if segue.identifier == "saveUnwind" {
            
            displayName.text = username
            
            
        }
    
    }
    

}


//
//  WelcomeViewController.swift
//  LivingWithEndo
//
//  Created by Kanoa Matton on 7/16/19.
//  Copyright © 2019 Kanoa Matton. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftKeychainWrapper
import Firebase



class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var enterName: UITextField!
    @IBOutlet weak var enterEmailContentView: UIView!
    @IBOutlet weak var enterPasswordContentView: UIView!
    
    @IBOutlet weak var signInSignOutControl: UISegmentedControl!
    @IBOutlet weak var enterEmail: UITextField!
    @IBOutlet weak var enterPassword: UITextField!
    @IBOutlet weak var signInSignOut: Round_Button!
    
    var isSignIn: Bool = true
    
    let ref = Database.database().reference()
    
    @IBOutlet weak var gradientView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setUpUI()

        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        enterEmailContentView.layer.cornerRadius = 14
        enterPasswordContentView.layer.cornerRadius = 14
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 50
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    

    @IBAction func doneButton(_ sender: Any) {
        
        //Name for username
        let name = enterEmail.text
        
        //Check for empty fields
        if(enterEmail.text!.isEmpty){

            //Display alert message
            displayAlertMessage(userMessage: "Please enter a valid email/password.")
            
        }
        
        //Store data
        //UserDefaults.standard.set(name, forKey: "name")
        //UserDefaults.standard.synchronize()
        
        //Confirmation alert
        let myAlert = UIAlertController(title: "Thank You!", message: "Welcome, " + name!, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Proceed", style: UIAlertAction.Style.default, handler: { (action) in self.dismiss(animated: true, completion: nil)})

        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        
        //This sets the boolean to true meaning that whenever they open the app again, it checks if this value is true, not making them sign in again. Basically can be used as a local "Log Out" function
        UserDefaults.standard.set(true, forKey: "userSignedIn")
        UserDefaults.standard.synchronize()
        
        
    }
    
    func displayAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "Invalid", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func selectorChanged(_ sender: Any) {
        
        isSignIn = !isSignIn
        
        if isSignIn == true{
            self.signInSignOut.setTitle("Sign In", for: .normal)
        }
        else {
            self.signInSignOut.setTitle("Sign Up", for: .normal)
        }
        
    }
    
    @IBAction func signInSignUpButton(_ sender: Any) {
        
        if let email = enterEmail.text, let password = enterPassword.text {
            
            
            
            if isSignIn == true {
                
                Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
                    
                    //Check user if nil
                    if user != nil {
                        //User found, go to mainscreen
                        
                        
                        //Set user defualt to save sign in info
                        UserDefaults.standard.set(true, forKey: "userSignedIn")
                        UserDefaults.standard.set(true, forKey: "reSignInUpdate1")
                        UserDefaults.standard.synchronize()
            
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    else {
                        //Error, display message
                        self.displayAlertMessage(userMessage: "Please Enter a valid email/password.")
                    }
                })
            }
            
            if isSignIn == false {
                
                
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    
                    //Check user if nil
                    if user != nil {
                        
                        
                        let user = Auth.auth().currentUser
                        let uid = user?.uid
                        
                    
                        let userEmail = self.enterEmail!.text
                        

                        
                        UserDefaults.standard.set(true, forKey: "userSignedIn")
                        UserDefaults.standard.set(true, forKey: "reSignInUpdate1")
                        
                        self.ref.child("Users/\(uid!)").setValue(["Email":userEmail! , "Password":password])
                        
                        self.ref.child("Users/\(uid!)/DailyRemedies").setValue(["0": "not done", "1": "not done", "2": "not done", "3": "not done", "4": "not done", "5": "not done", "6": "not done"])
                        
                        
                        
                    
                        
                        UserDefaults.standard.synchronize()
                        
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    else{
                        //display error message
                        if password.count < 6 {
                            self.displayAlertMessage(userMessage: "Password must be at least 6 characters.")
                        }
                        else{
                            self.displayAlertMessage(userMessage: "Please Enter a valid email and/or password.")
                        }

                    }
                })
            }
            
        }
        
        
    }
    
    

}

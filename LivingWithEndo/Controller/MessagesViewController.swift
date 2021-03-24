//
//  MessagesViewController.swift
//  LivingWithEndo
//
//  Created by MacBook on 3/22/21.
//  Copyright © 2021 Kanoa Matton. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class MessagesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTextFieldStackView: UIStackView!
    
    var messages: [String: [String:Any]] = [:]
    var keyboardHeight: CGRect?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
        
        let ref = Database.database().reference()
        let userUID = Auth.auth().currentUser?.uid
        
        ref.child("Community").child("Experiences").observe(DataEventType.value, with: { snapshot in
            if let experiencesMessages = snapshot.value as? [String : [String:Any]]  {
                
                self.messages = experiencesMessages
                // Structure to grab certain message and username, in this case
                //print(experiencesMessages["Message1"]!["username"]!)
                    
                } else {
                    //
                    self.messages = [:]
                }
            
            self.tableView.reloadData()
            
            
        })
        
        
        
        
        
    }
    
    func displayAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "No Username Detected", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("stack view y origin" + "\(self.messageTextFieldStackView.frame.origin.y)")
        print(" view height" + "\(self.view.frame.height)")
        print(" inset bottom height" + "\(self.view.safeAreaInsets.bottom)")
        
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                   // if keyboard size is not available for some reason, dont do anything
                   return
                }
            self.keyboardHeight = keyboardSize
            
            if self.messageTextFieldStackView.frame.origin.y == self.view.frame.height - self.view.safeAreaInsets.bottom - self.messageTextFieldStackView.frame.height{
                
        
                
                self.messageTextFieldStackView.frame.origin.y -= keyboardSize.height - self.view.safeAreaInsets.bottom
                //self.view.layoutIfNeeded()
                print(self.messageTextFieldStackView.frame.origin.y)
                //346
                //34
                
            }
        }
    }
    
    

    @objc func keyboardWillHide(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               // if keyboard size is not available for some reason, dont do anything
               return
            }
        
            self.messageTextFieldStackView.frame.origin.y += keyboardSize.height - self.view.safeAreaInsets.bottom
        print("new" + "\(self.messageTextFieldStackView.frame.origin.y)")
        
            //self.view.layoutIfNeeded()
        
    }
    
    
    @IBAction func dismissKeyboardSwipe(_ sender: UISwipeGestureRecognizer) {
        
        view.endEditing(true)
        //resignFirstResponder()
        
    }
    
    
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        let ref = Database.database().reference()
        let userUID = Auth.auth().currentUser?.uid
        
        if messageTextField.text!.isEmpty {
            return
        }
        else {
            
            ref.child("Community").child("Experiences").observe(DataEventType.value, with: { snapshot in
                if let experiencesMessages = snapshot.value as? [String : [String:Any]]  {
                    
                    self.messages = experiencesMessages
                    // Structure to grab certain message and username, in this case
                    //print(experiencesMessages["Message1"]!["username"]!)
                        
                    } else {
                        
                        self.messages = [:]
                        
                    }
                
                
            })
            
            // To adjust database bug where posting a message at the same time can create conflict, set a random short interval on when to post
            let randomInterval = Double.random(in: 0...2)
            
            // First check if the user has a display name, if it is nil then do not post message and give them an error
            if Auth.auth().currentUser?.displayName != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + randomInterval, execute: {
                    ref.child("Community/Experiences/Message\(self.messages.count+1)").setValue(["messageText": self.messageTextField.text, "userUID" : userUID, "username": Auth.auth().currentUser?.displayName])
                    
                })
            } else {
                displayAlertMessage(userMessage: "Please set a username for your account in order to publicly post onto the community. You can do that by pressing 'Edit Name' in the home page! Thank you!")
            }
            
            
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

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageTableViewCell
        
        //let userUID = messages["Message\(indexPath.row+1)"]?["userUID"] as? String
        cell?.messageText.text = messages["Message\(indexPath.row+1)"]?["messageText"] as? String ?? ""
        
        cell?.messageImage.translatesAutoresizingMaskIntoConstraints = false
        //cell?.messageImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        //cell?.messageImage.bottomAnchor.constraint(equalTo: (cell?.messageText.bottomAnchor)!).isActive = true
        
        //print(cell?.messageText.frame.height)
        
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
    
}



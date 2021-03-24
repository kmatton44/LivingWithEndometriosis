//
//  AddToDoViewController.swift
//  LivingWithEndo
//
//  Created by Kanoa Matton on 7/20/19.
//  Copyright © 2019 Kanoa Matton. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import Firebase

class AddToDoViewController: UIViewController {
    
    var manageContext: NSManagedObjectContext!
    var todo: Entity?
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneButton: Round_Button!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
 
        textView.becomeFirstResponder()
        
        if let todo = todo {
            textView.text = todo.item
            textView.text = todo.item

            
        }
    }
    
    
    
    @objc func keyboardWillShow(notification: Notification) {
        
       
        
        let key = "UIKeyboardFrameEndUserInfoKey"
        
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {return}
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
 
        
        UIView.animate(withDuration: 0.3, animations:{
            self.stackViewConstraint.constant = -keyboardHeight - 16

            self.view.layoutIfNeeded()
            
        })
        
        
        
    }
    

    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
        textView.resignFirstResponder()
    }
    
    @IBAction func doneButton(_ sender: Any) {
        guard let title = textView.text, !title.isEmpty else {
            return
        }
        
        
        if let todo = self.todo {
            todo.item = title
            todo.date = Date()
        } else {
            
            let todo = Entity(context: manageContext)
            todo.item = title
            todo.date = Date()
        }
        
        do {
            try manageContext.save()
            dismiss(animated: true)
            textView.resignFirstResponder()
        } catch {
            print("Error saving note: \(error)")
        }
        
        
    }
    
}

extension AddToDoViewController: UITextViewDelegate{
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneButton.isHidden{
            textView.text.removeAll()
            textView.textColor = .white
            
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3){
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

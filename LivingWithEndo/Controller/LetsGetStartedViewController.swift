//
//  LetsGetStartedViewController.swift
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

class LetsGetStartedViewController: UIViewController {

    @IBOutlet weak var informationLabelContentView: UIView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfRemediesCompletedLabel: UILabel!
    
    let ref = Database.database().reference()
    var numberOfRemediesCompleted: Int = 0
    
    var remediesFinished: [String] = []
    
    let remedies: [Remedies] = [
        Remedies(title: "Heat", description: "If your symptoms are acting up and you need relief, heat is one of the best home remedies you have at your disposal. Heat can relax the pelvic muscles, which can reduce cramping and pain. You can use warm baths, hot water bottles, or heating pads to treat cramping effectively." + "\n \n" + "Try to use this remedy on a daily basis to keep your body relaxed"),
        Remedies(title: "OTC Anti-Flammatory Medicine", description: "Over-the-counter nonsteroidal anti-inflammatory drugs can offer fast relief from painful cramping caused by endometriosis. These drugs include ibuprofen and naproxen. Make sure you take them with food or drink to prevent stomach upset and ulcers, and don’t use them for longer than one week."),
        Remedies(title: "Castor Oil", description: "Castor oil has been used for hundreds of years to treat endometriosis. It can be used at the very beginning, when cramping is first felt, to help the body get rid of excess tissues. It’s important that this technique is only used before the menstrual flow, and not during." + "\n \n" + "Castor oil should be massaged directly into the abdomen. You can also mix it with a few drops of a relaxing essential oil like lavender to help relax the pelvic muscles, and apply it to a warm compress to place on the abdomen." + "\n \n" + "Try to use this remedy on a daily basis to keep your body relaxed"),
        Remedies(title: "Turmeric", description: "Turmeric has strong anti-inflammatory properties that can be beneficial to people experiencing endometriosis symptoms. It can also be used to manage endometriosis in the long term. Some research has even found that it has the ability to inhibit endometrial growth." + "\n \n" + "You can take turmeric capsules, or make turmeric tea by boiling one cup of water and adding a teaspoon of both turmeric and ginger powder. You can also add honey and lemon. Drink this three times daily while experiencing symptoms, and at least once daily when you’re using it for maintenance."),
        Remedies(title: "Choosing Anti-Flammatory Foods", description: "This won’t offer fast symptom relief, but it could help manage the endometriosis long term. By avoiding foods that cause inflammation and increasing foods with anti-inflammatory properties in your diet, you can reduce symptoms in the future." + "\n \n" + "Foods to avoid include:" + "\n" + "dairy, processed foods high in refined sugars, caffeine, alcohol" + "\n \n" + "Foods to include:" + "\n" + "green leafy vegetables, broccoli, celery, blueberries, salmon, ginger, bone broth, and chia seeds"),
        Remedies(title: "Pelvic Massages", description: "Massaging the pelvic muscles can help relax them and reduce inflammation, reducing crampingTrusted Source. Using a few drops of high-quality lavender essential oil can help further relax the muscles. Gently massage the affected area for 10 to 15 minutes at a time." + "\n \n" +
            "Pelvic massages should only be used before the menstrual cycle; it may aggravate symptoms if you use it as a treatment during your period."),
        Remedies(title: "Ginger Tea", description: "Some people with endometriosis experience nausea as a result of the condition. Ginger tea is one of the best home remedies for treating nausea, and research has consistently shownTrusted Source that it’s both safe and effective." + "\n \n" + "You can purchase ginger tea packets at many supermarkets and grocery stores. Just add them to a cup of boiling water and drink two to three times daily when experiencing nausea.")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let userUID = Auth.auth().currentUser?.uid
        
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
            self.numberOfRemediesCompletedLabel.text = "\(self.numberOfRemediesCompleted) out of 7 remedies done!"
            // Update the table view
            self.tableView.reloadData()
            })
        
        setUpUI()
       
        
        
        
    }
    
    func setUpUI() {
        informationLabelContentView.layer.shadowOpacity = 0.6
        informationLabelContentView.layer.shadowRadius = 10
    }
    

    @IBAction func swipeGestureUsed(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left && pageControl.currentPage == 0 {
            pageControl.currentPage = 1
            informationLabel.text = "Fortunately, there are plenty of home remedies that you can use to help reduce symptoms fast."
        }
        else if sender.direction == .right && pageControl.currentPage == 1 {
            pageControl.currentPage = 0
            informationLabel.text = "Finding relief from symptoms is important for women trying to manage the condition, especially if a treatment plan hasn’t been worked out yet."
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRemedy" {
            
            let remedy = remedies[tableView.indexPathForSelectedRow!.row]
            let navController = segue.destination as! UINavigationController
            let remedyVC = navController.topViewController as! RemedyViewController
            
            remedyVC.remedy = remedy
            
        }
    }
    
    
    @IBAction func unwindToGetStartedViewController(segue: UIStoryboardSegue) {
        
        var userUID = Auth.auth().currentUser?.uid
        /*
        guard (segue.identifier == "finishedRemedy"), let sourceViewController = segue.source as? RemedyViewController else {return}*/
        
        //guard segue.identifier == "finishedRemedy", let username = sourceViewController.username else {return}
        
        
        if segue.identifier == "finishedRemedy" {
            
            let remedyID = tableView.indexPathForSelectedRow?.row
            
            Auth.auth().addStateDidChangeListener { (auth, user) in
                
                if user != nil {
                    userUID = auth.currentUser?.uid
                    
                    self.ref.child("Users/\(userUID!)/DailyRemedies/\(remedyID!)").setValue("done")
                    
                    
                    self.ref.child("Users").child(userUID!).child("DailyRemedies").observeSingleEvent(of: DataEventType.value, with: { snapshot in
                            if let remediesFinished = snapshot.value as? [String] {
                                self.remediesFinished = remediesFinished
                            } else {
                                //
                            }
                        self.numberOfRemediesCompleted = 0
                        for n in self.remediesFinished {
                            if n == "done" {
                                self.numberOfRemediesCompleted += 1
                            }
                        }
                        // Update the label
                        self.numberOfRemediesCompletedLabel.text = "\(self.numberOfRemediesCompleted) out of 7 remedies done!"
                        self.tableView.reloadData()
                        })
                    
                }
                
            }
            
    
            
            
            
        } else {
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
        
        
        
       
    }
    
   
}

extension LetsGetStartedViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remedies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "remedyCell", for: indexPath) as? RemedyTableViewCell
        cell?.remedyTitle.text = remedies[indexPath.row].title
        
        if remediesFinished.count > 0 {
            
            if remediesFinished[indexPath.row] == "done" {
                cell?.greenCheckImage.alpha = 1
            } else if remediesFinished[indexPath.row] == "not done" {
                cell?.greenCheckImage.alpha = 0
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toRemedy", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

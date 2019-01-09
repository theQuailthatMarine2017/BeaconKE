//
//  LoginRegisterViewController.swift
//  Get Promos
//
//  Created by RastaOnAMission on 12/12/2018.
//  Copyright © 2018 ronyquail. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class LoginRegisterViewController: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        welcomeLabel.alpha = 0
        segment.alpha = 0
        phone.alpha = 0
        password.alpha = 0
    }
    
    func animate() {
        
        UIView.animate(withDuration: 1.5) {
            self.welcomeLabel.alpha = 1
            self.segment.alpha = 1
            self.phone.alpha = 1
            self.password.alpha = 1
            
            self.welcomeLabel.frame.origin.y -= 20
        }
        
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
        
    }
    
    @IBAction func `continue`(_ sender: Any) {
        
        let index = segment.selectedSegmentIndex
        
        
        if index == 0 {
            // Login User Firebase
            signIn(email: phone.text!, password: password.text!)
        }
        
        if index == 1 {
            // Register User Firebase
            
            if phone == nil && password == nil {
                
                ProgressHUD.showError("Fill All Fields!")
                
            } else {
                
                createUser(email: phone.text!, password: password.text!)
            }
        }
        
  
    }
    
    
    func createUser(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                
                ProgressHUD.showError("\(error!.localizedDescription)")
                
            } else {
                
                DispatchQueue.main.async {
                    ProgressHUD.showSuccess("Registered!")
                    self.performSegue(withIdentifier: "toApp", sender: self)
                }
                
            }
            
        }
        
    }
    
    func signIn(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                ProgressHUD.showError("\(error!.localizedDescription)")
            } else {
                
                DispatchQueue.main.async {
                    ProgressHUD.showSuccess("Welcome Back!")
                    self.performSegue(withIdentifier: "toApp", sender: self)
                }
            }
            
        }
        
    }
    
    
    

}

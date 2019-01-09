//
//  CompleteRegistrationViewController.swift
//  Get Promos
//
//  Created by RastaOnAMission on 13/12/2018.
//  Copyright © 2018 ronyquail. All rights reserved.
//

import UIKit

class CompleteRegistrationViewController: UIViewController {
    
    
    var firstName: String?
    var lastName: String?
    var phone: String!
    var password: String!
    
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: Any) {
        
        // finish user registration
        
        
        // present scan beacons view controller
        
        let avBeaconsVC = UIStoryboard.init(name: "scan", bundle: nil).instantiateInitialViewController() as! ScanBeaconsTableViewController
        
        self.present(avBeaconsVC, animated: true, completion: nil)
        
    }
    
    // pops current view controller of the stack
    
    
    @IBAction func goBack(_ sender: Any) {
        
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
    }
    
 

}

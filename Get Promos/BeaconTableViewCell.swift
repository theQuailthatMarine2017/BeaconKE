//
//  BeaconTableViewCell.swift
//  Get Promos
//
//  Created by RastaOnAMission on 13/12/2018.
//  Copyright © 2018 ronyquail. All rights reserved.
//

import UIKit

class BeaconTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var beaconIcon: UIImageView!
    @IBOutlet weak var beaconTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        beaconIcon.layer.borderWidth = 1
        beaconIcon.layer.masksToBounds = false
        beaconIcon.layer.borderColor = UIColor.blue.cgColor
        beaconIcon.layer.cornerRadius = beaconIcon.frame.height / 2
        beaconIcon.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func defaultCell(image: UIImage, title: String) {
        
        beaconIcon.image = image
        beaconTitle.text = title
        
    }
    
    func generateCell(beacons: [String:Any]) {
        
        let imageUrl:URL = URL(string: beacons["Image"]! as! String)!
        let imageData:NSData = NSData(contentsOf: imageUrl)!
        let image = UIImage(data: imageData as Data)!
        
        beaconIcon.image = image
        beaconTitle.text = beacons["Title"] as? String
        
    }

}

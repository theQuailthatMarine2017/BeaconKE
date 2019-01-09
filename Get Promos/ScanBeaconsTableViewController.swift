//
//  ScanBeaconsTableViewController.swift
//  Get Promos
//
//  Created by RastaOnAMission on 13/12/2018.
//  Copyright © 2018 ronyquail. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation
import MTBeaconPlus
import ProgressHUD
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

class ScanBeaconsTableViewController: UITableViewController, CBCentralManagerDelegate, CLLocationManagerDelegate {
    
    var managerBeacon = MTCentralManager()
    var locationManager = CLLocationManager()
    var btManager =  CBCentralManager()
    var region: CLBeaconRegion?
    
    var beaconDict : Dictionary = ["UUID": "", "Major": ""]
    var beaconCount: Int = 0
    var knowBeacons: [CLBeacon] = []
    var beaconID: String?
    var beaconIDs: [String] = []
    var activeBeacon: [String:Any]?


    override func viewDidLoad() {
        super.viewDidLoad()
        let footerView = UIView()
        footerView.alpha = 0.4
        self.tableView.tableFooterView = footerView
        btManager = CBCentralManager(delegate: self, queue: nil)
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        scan()
        
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if btManager.state == .poweredOn {
            
        } else {
            print("Please switch on your bluetooth")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        knowBeacons = beacons.filter { $0.proximity != .unknown }
        
        locationManager.stopRangingBeacons(in: region)
        managerBeacon.stopScan()
        managerBeacon.state = .poweredOff
        ProgressHUD.dismiss()
        tableView.reloadData()
        
        print(knowBeacons.count)
        beaconCount = knowBeacons.count
        print(knowBeacons)
        
        
        
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let header: String = "Closest Beacon To You"
        
        return header
        
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        let footer: String = "Powered by Beacons KE LTD"
        
        
        return footer
        
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if beaconCount == 0 {
            return 1
        } else {
           return beaconCount
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if activeBeacon != nil {
            
            let beaconContentVC = ViewController()
            
            beaconContentVC.label = activeBeacon!["Title"] as? String
            beaconContentVC.urlContent = activeBeacon!["URL"] as? String
            
            navigationController?.pushViewController(beaconContentVC, animated: true)
            
        }
        
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "beacon", for: indexPath) as! BeaconTableViewCell
        
        // get beacons details from firebase db using beaconScanned array
        
        if beaconCount == 0 {
            
            cell.defaultCell(image: UIImage(named: "bt")!, title: "Click Green Scan Icon On Top Right")
            
            
        } else {
            
            for beacon in knowBeacons {
                
                if beacon.proximityUUID.description != " " {
                    beaconID = "\(beacon.proximityUUID)%\(beacon.major)"
                    beaconIDs.append(beaconID!)
//                    beaconCount = beaconIDs.count
//                    tableView.reloadData()
                    print(beaconIDs.count)
                    print(beaconIDs)
                    
                    
                    
                    let ids = beaconIDs[indexPath.row]
                    
                    
                    let db = Firestore.firestore()
                    db.collection("beacons").document(ids).getDocument { (snapshot, error) in
                        
                        if error != nil {
                            
                        }
                        
                        self.activeBeacon = (snapshot?.data())!
                        
                        DispatchQueue.main.async {
                            
                            cell.generateCell(beacons: self.activeBeacon!)
                    
                        }
                        
                        
                    }
                    
                    
                } else {
                    scan()
                }
                
                
            }
            
            
            
        }
        
        knowBeacons.removeAll()
        beaconIDs.removeAll()
        return cell
        
    }
    
    @IBAction func reScan(_ sender: Any) {
        
        scan()
        
    }
    
    @IBAction func logout(_ sender: Any) {
        
        let alert = UIAlertController(title: "Log Out", message: "Are You Sure You Want To Log Out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style:.destructive, handler: { (action) in
            
            action.isEnabled = true
            print(action)
            
            if action.title == "Yes" {
                self.navigationController?.popViewController(animated: true)
            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func scan() {
        
        beaconIDs = []
        
        beaconCount = 0
        
        knowBeacons = []
        
        beaconDict = ["UUID": "", "Major": ""]
        
        managerBeacon.state = .poweredOn
        
        ProgressHUD.show("Scanning for Beacons..")
        
        managerBeacon.startScan { (peripherial) in
            
            if peripherial == nil {
                ProgressHUD.showError("No Beacons In Range. Click Scan To Try Again")
            }
            
            for device in peripherial! {
                
                
                let frames = device.framer?.advFrames
                
                for frame in frames! {
                    
                    switch(frame.frameType) {
                        
                    case .FrameUID:
                        
                        let uid = frame
                        print("\(uid)")
                        self.managerBeacon.stopScan()
                        break
                        
                    case .FrameiBeacon:
                        
                        ProgressHUD.show("Analyzing Beacons")
                        
                        let uuid = UUID.init(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
                        
                        self.region = CLBeaconRegion(proximityUUID: uuid!, identifier: device.identifier)
                        
                        
                        self.locationManager.startRangingBeacons(in: self.region!)
                        
                        break
                        
                    case .FrameURL:
                        
                        let url = frame
                        print("\(url)")
                        self.managerBeacon.stopScan()
                        break
                        
                    case .FrameDeviceInfo:
                        
                        let info = frame
                        print("\(info)")
                        self.managerBeacon.stopScan()
                        break
                        
                    case .FrameNone:
                        
                        let none = frame
                        print(none)
                        self.managerBeacon.stopScan()
                        break
                        
                    case .FrameConnectable:
                        
                        let connectable = frame
                        print(connectable)
                        self.managerBeacon.stopScan()
                        break
                        
                    case .FrameUnknown:
                        
                        print("unknown")
                        self.managerBeacon.stopScan()
                        break
                    case .FrameTLM:
                        
                        let tlm = frame
                        print(tlm)
                        self.managerBeacon.stopScan()
                        break
                        
                    case .FrameHTSensor:
                        
                        print("sensor")
                        self.managerBeacon.stopScan()
                        break
                    case .FrameAccSensor:
                        
                        print("accsnesor")
                        self.managerBeacon.stopScan()
                        break
                    case .FrameLightSensor:
                        print("lihjy sensor")
                        self.managerBeacon.stopScan()
                        break
                    case .FrameQlock:
                        print("qlock")
                        self.managerBeacon.stopScan()
                        break
                    case .FrameDFU:
                        print("dfu")
                        self.managerBeacon.stopScan()
                        break
                    case .FrameRoambee:
                        print("roambee")
                        self.managerBeacon.stopScan()
                        break
                    case .FrameForceSensor:
                        print("force sensor")
                        self.managerBeacon.stopScan()
                        break
                    }
                }
                
            }
            
            
            
        }
        
    }
    
    


}

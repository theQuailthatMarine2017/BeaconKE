//
//  ViewController.swift
//  Get Promos
//
//  Created by RastaOnAMission on 10/12/2018.
//  Copyright © 2018 ronyquail. All rights reserved.
//

import UIKit
import WebKit
import ProgressHUD

class ViewController: UIViewController, WKNavigationDelegate{
    
    
    var contentView: WKWebView!
    var urlContent: String!
    var label: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView = WKWebView()
        contentView.navigationDelegate = self
        view = contentView
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = label
        loadContent(url: urlContent, label: label)
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ProgressHUD.show("Fetching Content.....")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }
    
    
    func loadContent(url: String, label: String) {
        
        let site = URL(string: url)!
        let request = URLRequest(url: site)
        
        DispatchQueue.main.async {
            self.contentView.load(request)
            self.contentView.allowsBackForwardNavigationGestures = true
        }
        
        
    }

}

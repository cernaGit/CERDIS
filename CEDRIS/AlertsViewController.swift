//
//  AlertsViewController.swift
//  
//
//  Created by Tomáš Skála on 16.11.2021.
//

import UIKit
import WebKit

class AlertsViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
            let url = URL(string: "https://app.goodapps.cz/dopravabrno/idsjmk.php")
            webView.load(URLRequest(url: url!))
        webView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
    }
    
}

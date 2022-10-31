//
//  InfoController.swift
//  Rutio
//
//  Created by Kateřina Černá on 18.11.2020.
//

import UIKit

class InfoController: UIViewController {
    
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    
    @IBOutlet weak var detailContactLabel: UILabel!
    
    
    @IBOutlet weak var darkMode: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.version.text = "version".localized()
        self.darkModeLabel.text = "dark_mode".localized()
        self.contactLabel.text = "contacts".localized()
        self.detailContactLabel.text = "detail_contact".localized()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchIsOn(_ sender: Any) {
        if darkMode.isOn {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        } else {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
}


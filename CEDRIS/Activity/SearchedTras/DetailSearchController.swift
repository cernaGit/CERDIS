//
//  DetailSearchController.swift
//  Rutio
//
//  Created by Kateřina Černá on 06.03.2021.
//

import UIKit
import CoreData

class DetailSearchController: UIViewController{
    @IBOutlet weak var startSearchLabel: UILabel!
    @IBOutlet weak var destinationSearchLabel: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailHisotryItem {
            if let start = startSearchLabel {
                start.text = detail.start
            }
            if let destination = destinationSearchLabel {
                destination.text = detail.destination
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    var detailHisotryItem: HistorySearch? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}

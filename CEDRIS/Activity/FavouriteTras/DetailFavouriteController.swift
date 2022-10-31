//
//  DetailFavouriteController.swift
//  Rutio
//
//  Created by Kateřina Černá on 01.01.2021.
//

import UIKit
import CoreData

class DetailFavouriteController: UIViewController{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let name = nameLabel {
                name.text = detail.name
            }
            if let start = startLabel {
                start.text = detail.start
            }
            if let destination = destinationLabel {
                destination.text = detail.destination
            }
        
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: FavouriteTras? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}

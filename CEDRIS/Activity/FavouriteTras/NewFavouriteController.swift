//
//  NewFavouriteController.swift
//  Rutio
//
//  Created by Kateřina Černá on 11.12.2020.
//

import UIKit
import CoreData

class NewFavouriteController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTrasLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    var newStartDestination = Location()
    var newEndDestination = Location()
    
    var saveDelegate: FavouriteTrasManagerDelagate? = nil
    var selectedFavouriteTras: String?
    var dataList : [From2] = [From2]()
    var tableView: UITableView?
    var searching = false
    var searchedTras = [String]()

    
    @IBOutlet weak var startFavouriteTras: UIButton!
    @IBOutlet weak var destinationFavouriteTras: UIButton!
    @IBOutlet weak var nameFavouriteTras: UITextField!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTrasLabel.text = "name".localized()
        self.startLabel.text = "Start".localized()
        self.destinationLabel.text = "Destination".localized()
        
        startFavouriteTras.layer.cornerRadius = 5
        destinationFavouriteTras.layer.cornerRadius = 5
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "stopFavouriteView"{
            let controller = segue.destination as! StopFavouriteViewController
            controller.plan = self
        }else if segue.identifier == "stop2FavouriteView"{
            let controller = segue.destination as! Stop2FavouriteViewController
            controller.plan = self
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let name = nameFavouriteTras.text ?? "No name"
        let start = startFavouriteTras.title(for: UIControl.State.normal) ?? "No start"
        let destination = destinationFavouriteTras.title(for: UIControl.State.normal) ?? "No destionation"
        let newStartDestinationSave = newStartDestination
        let newEndDestinationSave = newEndDestination
        if let store = saveDelegate{
            store.insertTras(name: name, start: start, destination: destination, lat1: newStartDestinationSave.latitude, lat2: newEndDestinationSave.latitude, long1: newStartDestinationSave.longitude, long2: newEndDestinationSave.longitude)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}

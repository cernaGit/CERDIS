//
//  StopFavouriteViewController.swift
//  Rutio
//
//  Created by Kateřina Černá on 26.04.2021.
//

import UIKit
import CoreData

class StopFavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var stopSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchPoints = [From2]()
    var pointJson = [From2]()
    var searching = false
    var choodeStopData = UIPickerView()
    var plan = NewFavouriteController()
    var rowIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopSearch.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        stopSearch.placeholder = "Search"
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Data is reloading..")
        refreshControl.addTarget(self, action: #selector(tableView.reloadData), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        // Do any additional setup after loading the view, typically from a nib.
        loadJSONData { from in
            self.pointJson = from
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      if let indexPath = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: indexPath, animated: true)
      }
    }
    
    func loadJSONData(completion: @escaping ([From2]) -> Void) {
        
        if let url = URL(string: "https://api.rutio.eu/otp/routers/zagreb/index/stops/") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error == nil {
                    do {
                        let data = try JSONDecoder().decode([From2].self, from: data!)
                        DispatchQueue.main.async {
                            completion(data)
                        }
                    } catch let jsonError{
                        print("An error occurred + \(jsonError)")
                    }
                }
            }.resume()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchPoints.count
        } else {
            return pointJson.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let stopCell = tableView.dequeueReusableCell(withIdentifier: "stopFavourite") else {
            return UITableViewCell()
        }
        if searching {
            stopCell.textLabel?.text = searchPoints[indexPath.row].name
        } else {
            stopCell.textLabel?.text = pointJson[indexPath.row].name
        }
        return stopCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        self.rowIndex = indexPath!.row
        let selectedStop = searchPoints[self.rowIndex].name
        let hideStopLat = searchPoints[self.rowIndex].lat
        let hideStopLon = searchPoints[self.rowIndex].lon
        self.plan.startFavouriteTras?.setTitle(selectedStop, for: UIControl.State.normal)
        self.plan.newStartDestination.latitude = hideStopLat
        self.plan.newStartDestination.longitude = hideStopLon
        self.plan.startFavouriteTras?.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
}

extension StopFavouriteViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPoints = pointJson.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
}

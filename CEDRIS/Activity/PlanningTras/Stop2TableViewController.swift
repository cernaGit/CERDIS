//
//  Stop2TableViewController.swift
//  Rutio
//
//  Created by Kateřina Černá on 24.03.2021.
//

import UIKit
import CoreData

class Stop2TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var stopSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchPoints = [From2]()
    var pointJson = [From2]()
    var searching = false
    var choodeStopData = UIPickerView()
    var plan: PlanningTrasController?
    var rowIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopSearch.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
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
    
    func loadJSONData(completion: @escaping ([From2]) -> Void) {
        
        if let url = URL(string: "https://api.rutiozagreb.com/stops.php") {
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
        guard let stopCell = tableView.dequeueReusableCell(withIdentifier: "stopCell2") else {
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
        var selectRow = self.rowIndex
        selectRow = indexPath.row
        let selectedStop = searchPoints[selectRow].name
        let hideStopLat = searchPoints[selectRow].lat
        let hideStopLon = searchPoints[selectRow].lon
        self.plan?.startStopSearch?.setTitle(selectedStop, for: UIControl.State.normal)
        self.plan?.startDestination.latitude = hideStopLat
        self.plan?.startDestination.longitude = hideStopLon
        print("didSelectRowAt \(selectRow)")
        //self.plan?.startStopSearch?.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchPoints.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
    
    @IBAction func doneAndSave(_ sender: Any) {
    }
}

extension Stop2TableViewController: UISearchBarDelegate {
    
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

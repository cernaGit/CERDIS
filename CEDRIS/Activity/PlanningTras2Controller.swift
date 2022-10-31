//
//  PlanningTras2Controller.swift
//  Rutio
//
//  Created by Kateřina Černá on 03.02.2021.
//

import UIKit
import CoreData
//import SwiftyJSON

class PlanningTras2Controller: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, NSFetchedResultsControllerDelegate, HistoryManagerDelegate, UISplitViewControllerDelegate {
   

    @IBOutlet weak var startPlanner: UITextField!
    @IBOutlet weak var destinationPlanner: UITextField!
    @IBOutlet weak var dateTextFiled: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var transportTextFiled: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var swapButton: UIButton!
    
    let datePicker = UIDatePicker()
    let datePickerr = UIDatePicker()
    let transportPicker = UIPickerView()
    
    var pickerTransportData: [String] = [String]()
    
    var saveDelegate: HistoryManagerDelegate? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        showDatePicker()
        showTimePicker()
        showTransferPicker()
        
        transportPicker.delegate = self
        self.transportPicker.delegate = self
        self.transportPicker.dataSource = self
        
        pickerTransportData = ["MHD", "TAXI", "Bikesharing", "Walk", "Scooter"]
        transportTextFiled.inputView = transportPicker

        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
        
        
        if let url = URL(string: "https://api.rutio.eu/otp/routers/zagreb/index/stops/") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                
                let dataAsString = String(data: data, encoding: .utf8)
                print(dataAsString)
                
                do {
                    let children  = try
                        JSONDecoder().decode(Response.self, from: data)
                    print (children)
                } catch let jsonErr {
                    print ("Error serializing json: ", jsonErr)
                }
            }.resume()
        }
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerTransportData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerTransportData[row]
    }
    
    func pickerView( pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        transportTextFiled.text = pickerTransportData[row]
    }
    
    func showTransferPicker(){
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTrasportPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
          let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTransportPicker));

         toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        transportTextFiled.inputAccessoryView = toolbar
        // add datepicker to textField
        transportTextFiled.inputView = transportPicker
    }
    
    @objc func doneTrasportPicker(){
        let row = self.transportPicker.selectedRow(inComponent: 0)
                self.transportPicker.selectRow(row, inComponent: 0, animated: false)
                self.transportTextFiled.text = self.pickerTransportData[row]
        transportTextFiled.resignFirstResponder()
    }
    
    @objc func cancelTransportPicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func showDatePicker(){
        //Formate Date
        datePickerr.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
          let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

         toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        dateTextFiled.inputAccessoryView = toolbar
        // add datepicker to textField
        dateTextFiled.inputView = datePickerr
        
    }
    
    @objc func doneDatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        dateTextFiled.text = formatter.string(from: datePickerr.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func showTimePicker(){
        //Formate Date
        datePicker.datePickerMode = .time
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
          let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTimePicker));

         toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        timeTextField.inputAccessoryView = toolbar
        // add datepicker to textField
        timeTextField.inputView = datePicker
        
    }
    
    @objc func doneTimePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeTextField.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelTimePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    @IBAction func swapButton(_ sender: Any) {
        let tempPos : CGPoint = startPlanner.frame.origin
        UIView.beginAnimations(nil, context: nil)
        // Set textFieldOne to textFieldTwo's position
        startPlanner.frame.origin = destinationPlanner.frame.origin
        // Set textFieldTwo to textFieldOne's original position
        destinationPlanner.frame.origin = tempPos
        UIView.commitAnimations()
    }
    
    @IBAction func saveHistorySearch(_ sender: Any) {
        let start = startPlanner.text ?? "No start"
        let destination = destinationPlanner.text ?? "No destionation"
        if let store = saveDelegate{
          store.insertHistory(start: start, destination: destination)
        }
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        let context = self.fetchedResultsController.managedObjectContext
        let newEvent = Events(context: context)
        
        // If appropriate, configure the new managed object.
        newEvent.timestamp = Date()
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func insertHistory(start: String, destination: String) {
        let context = self.fetchedResultsController.managedObjectContext
        let newHistory = HistorySearch(context: context)
        
        newHistory.start = start
        newHistory.destination = destination
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        let historyTrasSearch = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withHistorySearch: historyTrasSearch)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func configureCell(_ cell: UITableViewCell, withHistorySearch historySearch: HistorySearch) {
        cell.textLabel?.text = historySearch.start
        cell.textLabel?.text = historySearch.destination
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.textLabel?.textColor = UIColor.white
        cell.clipsToBounds = true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<HistorySearch> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        self.managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<HistorySearch> = HistorySearch.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "start", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<HistorySearch>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, withHistorySearch: anObject as! HistorySearch)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, withHistorySearch: anObject as! HistorySearch)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}

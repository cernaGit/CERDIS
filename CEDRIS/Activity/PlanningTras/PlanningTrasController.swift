//
//  PlanningTras.swift
//  Rutio
//
//  Created by Kateřina Černá on 18.11.2020.
//

import UIKit
import CoreData

//import SwiftyJSON

class PlanningTrasController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,  NSFetchedResultsControllerDelegate, UISplitViewControllerDelegate{
    
    @IBOutlet weak var TitleTrasLabel: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chooseTransportLabel: UILabel!
    @IBOutlet weak var searchHistoryLabel: UILabel!
    
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var transportTextFiled: UITextField!
    @IBOutlet weak var dateTextFiled: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    
    @IBOutlet weak var startStopSearch: UIButton!
    @IBOutlet weak var destinationStopSearch: UIButton!
    @IBOutlet weak var swapButton: UIButton!
    
    @IBOutlet weak var latStart: UILabel!
    @IBOutlet weak var lonStart: UILabel!
    @IBOutlet weak var latDestination: UILabel!
    @IBOutlet weak var lonDestination: UILabel!
    
    var startDestination = Location()
    var endDestination = Location()
    
    private var pointJson = [From2]()
    private var json: [From2] = []
    
    
    let datePicker = UIDatePicker()
    let datePickerr = UIDatePicker()
    let transportPicker = UIPickerView()
    
    var pickerTransportData: [String] = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    var saveDelegate: HistoryManagerDelegate? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var buttonIsSelected = false
    var favorites = [FavouriteTras]()
    let image1 = UIImage(named: "star.fill") as UIImage?
    let image2 = UIImage(named: "star") as UIImage?
    
    
    var detailViewController: SearchedTrasController? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? SearchedTrasController
        }
        
        //Localizable
        self.TitleTrasLabel.text = "Planning tras".localized()
        self.start.text = "Start".localized()
        self.destination.text = "Destination".localized()
        self.dateLabel.text = "Date".localized()
        self.timeLabel.text = "Time".localized()
        //self.chooseTransportLabel.text = "Choose transport".localized()
        self.searchHistoryLabel.text = "Search history".localized()
        self.searchButton.setTitle("Search".localized(), for: .normal)
        
        startStopSearch.layer.cornerRadius = 5
        destinationStopSearch.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
        showDatePicker()
        showTimePicker()
        //showTransferPicker()
        
        //trastport picker
        transportPicker.delegate = self
        self.transportPicker.delegate = self
        self.transportPicker.dataSource = self
        
        pickerTransportData = ["MHD", "BUS", "Bikesharing", "Scooter", "Walk"]
        //transportTextFiled.inputView = transportPicker
        
        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
        
        let fetchedRequest: NSFetchRequest<FavouriteTras> = FavouriteTras.fetchRequest()
        do {
            let favorite = try PersistenceService.context.fetch(fetchedRequest)
            for fav in favorite {
                resetAllRecord(entity: fav.favorite)
                buttonIsSelected = fav.favorite
                print("fav.favorite: \(fav.favorite)")
                print("button: \(buttonIsSelected)")
                if fav.favorite == true {
                    let onOffButton = UIButton(type: .system)
                    onOffButton.setImage(image2, for: .normal)
                }
            }
        } catch {
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // load JSON data from From (name,lat,long)
    func loadJSONdata(){
        if let url = URL(string: "https://api.rutio.eu/otp/routers/zagreb/index/stops/") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error == nil {
                    do {
                        self.pointJson = try JSONDecoder().decode([From2].self, from: data!)
                        
                        DispatchQueue.main.async {
                            
                            for state in self.pointJson {
                                print(state.name)
                                
                            }
                        }
                    } catch let jsonError{
                        print("An error occurred + \(jsonError)")
                    }
                }
            }.resume()
        }
    }
    
    
    @IBAction func onOffButtonPressed(_ sender: Any) {
        let onOffButton = UIButton(type: .system)
        buttonIsSelected = !buttonIsSelected
        if buttonIsSelected == true {
            onOffButton.setImage(image2, for: .normal)
        } else if buttonIsSelected == false {
            onOffButton.setImage(image1, for: .normal)
        }
        saveBool(bool: buttonIsSelected)
    }
    
    //save to core data
    func saveBool(bool: Bool) {
        if bool == true {
            print("favorite")
            print("buttonIsSelected \(buttonIsSelected)")
            let liked = FavouriteTras(context: PersistenceService.context)
            liked.favorite = bool
            PersistenceService.saveContext()
            favorites.append(liked)
        } else if bool == false {
            print("unfavorite")
            print("buttonIsSelected \(buttonIsSelected)")
            let liked = FavouriteTras(context: PersistenceService.context)
            liked.favorite = bool
            PersistenceService.saveContext()
            favorites.append(liked)
        }
    }
    
    //clears core data so it doens't get full
    func resetAllRecord(entity: Bool) {
        let context = PersistenceService.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
     {
        try context.execute(deleteRequest)
        try context.save()
     }
        catch
        {
            print ("There was an error")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        tableView.frame = view.bounds
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
    
    /* func pickerView( pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
     
     //save
     @objc func doneTrasportPicker(){
     let row = self.transportPicker.selectedRow(inComponent: 0)
     self.transportPicker.selectRow(row, inComponent: 0, animated: false)
     self.transportTextFiled.text = self.pickerTransportData[row]
     transportTextFiled.resignFirstResponder()
     }
     
     @objc func cancelTransportPicker(){
     //cancel button dismiss datepicker dialog
     self.view.endEditing(true)
     }*/
    
    
    func showDatePicker(){
        //Formate Date
        datePickerr.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        if #available(iOS 13.4, *) {
            datePickerr.preferredDatePickerStyle = .wheels
            datePickerr.sizeToFit()
        }
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
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        //done button & cancel button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTimePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        timeTextField.inputAccessoryView = toolbar
        // add datepicker to textField
        timeTextField.inputView = datePicker
        
    }
    
    @IBAction func searchButton(_ sender: Any) {
        if let _text = startStopSearch.titleLabel, _text.isHidden {
            let alert = UIAlertController(title: "Did you bring your towel?", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }
        if let _text = destinationStopSearch.titleLabel, _text.isHidden {
            let alert = UIAlertController(title: "Did you bring your towel?", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }
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
    
    
    @IBAction func swapTextField(_ sender: Any) {
        // Store textFieldOne's postition
        let tempPos : CGPoint = startStopSearch.frame.origin
        UIView.beginAnimations(nil, context: nil)
        // Set textFieldOne to textFieldTwo's position
        startStopSearch.frame.origin = destinationStopSearch.frame.origin
        // Set textFieldTwo to textFieldOne's original position
        destinationStopSearch.frame.origin = tempPos
        UIView.commitAnimations()
    }
    
    @IBAction func saveHistoryButton(_ sender: Any) {
        let start = startStopSearch.title(for: UIControl.State.normal) ?? "No start"
        let destination = destinationStopSearch.title(for: UIControl.State.normal) ?? "No destionation"
        if let store = saveDelegate{
            store.insertHistory(start: start, destination: destination)
        }
        //dismiss(animated: true, completion: nil)f
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
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchHistoryTable" {
            let controller = segue.destination as! PlanningTrasController
            controller.saveDelegate = self
        }else if segue.identifier == "startStopView"{
            let controller = segue.destination as! Stop2TableViewController
            controller.plan = self
        }else if segue.identifier == "destinationStopView"{
            let controller = segue.destination as! StopTableViewController
            controller.plan = self
        }else if segue.identifier == "showFavouriteStop"{
            let controller = segue.destination as! FavouriteController
            controller.plan = self
        }else if segue.identifier == "searchedPlan"{
            if let controller = segue.destination as? UITabBarController{
                controller.viewControllers?.forEach {
                    if let viewController = ($0 as? UINavigationController)?.topViewController as? SearchedTrasController{
                        viewController.planning = self
                    }
                    if let viewController = ($0 as? UINavigationController)?.topViewController as? SearchMapPointController{
                        viewController.planning = self
                    }
                    
                }
            }
        }
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
            configureCell(tableView.cellForRow(at: indexPath!)! as! SearchHistoryCell, withHistorySearch: anObject as! HistorySearch)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)! as! SearchHistoryCell, withHistorySearch: anObject as! HistorySearch)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

// MARK: - Table View

extension PlanningTrasController: UITableViewDelegate, UITableViewDataSource, HistoryManagerDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! SearchHistoryCell
        let historyTrasSearch = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withHistorySearch: historyTrasSearch)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    func configureCell(_ cell: SearchHistoryCell, withHistorySearch historySearch: HistorySearch) {
        cell.textLabel?.text = historySearch.start
        //cell.textLabel?.text = historySearch.destination
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.textLabel?.textColor = UIColor.white
        cell.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}

extension String{
    func localized()-> String {
        return NSLocalizedString(self, tableName: "Localize",bundle: .main, value: self ,comment: self)
    }
}

extension UIToolbar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 60)
    }
}

struct Location {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
}


//
//  DepartmentController.swift
//  Rutio
//
//  Created by Kateřina Černá on 18.11.2020.
//

import UIKit
import CoreData

class FavouriteController: UITableViewController, NSFetchedResultsControllerDelegate, FavouriteTrasManagerDelagate, UISplitViewControllerDelegate {
    
    
    
    var detailFavouriteTras: DetailFavouriteController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var plan: PlanningTrasController?
    var planning = NewFavouriteController()

    
    var buttonIsSelected = false
    var favorites = [FavouriteTras]()
    let image1 = UIImage(named: "star.fill") as UIImage?
    let image2 = UIImage(named: "star") as UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "favourite_tras".localized()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailFavouriteTras = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailFavouriteController
        }
        
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
    
    @IBAction func addFavourite(_ sender: UIButton) {
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
    
    func insertTras(name: String, start: String, destination: String, lat1: Double, lat2: Double, long1: Double, long2: Double) {
        let context = self.fetchedResultsController.managedObjectContext
        let newTras = FavouriteTras(context: context)
        
        newTras.name = name
        newTras.start = start
        newTras.destination = destination
        newTras.latitudeStart = lat1
        newTras.latitudeDestination = lat2
        newTras.longitudeStart = long1
        newTras.longitudeDestination = long2
        
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
        if segue.identifier == "showFavouriteStop" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = fetchedResultsController.object(at: indexPath)
                let controller = segue.destination as! PlanningTrasController
                plan = controller
                
            }
        } else if segue.identifier == "newFavouriteController" {
            let controller = (segue.destination as! UINavigationController).topViewController as! NewFavouriteController
            controller.saveDelegate = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavouriteTableViewCell
        let favouriteTras = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withFavouriteTras: favouriteTras)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favouriteTras = fetchedResultsController.object(at: indexPath)
        let selectedStopS = favouriteTras.start
        let selectedStopD = favouriteTras.destination
        let hideStopLatStart = favouriteTras.latitudeStart
        let hideStopLonStart = favouriteTras.longitudeStart
        let hideStopLatDestination = favouriteTras.latitudeDestination
        let hideStopLonDestination = favouriteTras.latitudeDestination

            self.plan?.startStopSearch?.setTitle(selectedStopS, for: UIControl.State.normal)
            self.plan?.startStopSearch?.resignFirstResponder()
            self.plan?.destinationStopSearch?.setTitle(selectedStopD, for: UIControl.State.normal)
            self.plan?.destinationStopSearch?.resignFirstResponder()
            self.planning.newStartDestination.latitude = hideStopLatStart
            self.planning.newStartDestination.longitude = hideStopLonStart
            self.planning.newEndDestination.latitude = hideStopLatDestination
            self.planning.newEndDestination.longitude = hideStopLonDestination
            print(planning.newStartDestination)
        //dismiss(animated: true, completion: nil)
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
    
    func configureCell(_ cell: FavouriteTableViewCell, withFavouriteTras favouriteTras: FavouriteTras) {
        /*cell.textLabel?.text = favouriteTras.name
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.textLabel?.textColor = UIColor.white
        cell.clipsToBounds = true*/
        cell.nameLabel.text = favouriteTras.name
        cell.startLabel.text = favouriteTras.start
        cell.destinationLabel.text = favouriteTras.destination

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<FavouriteTras> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        self.managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<FavouriteTras> = FavouriteTras.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
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
    var _fetchedResultsController: NSFetchedResultsController<FavouriteTras>? = nil
    
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
            configureCell(tableView.cellForRow(at: indexPath!)! as! FavouriteTableViewCell, withFavouriteTras: anObject as! FavouriteTras)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)! as! FavouriteTableViewCell, withFavouriteTras: anObject as! FavouriteTras)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

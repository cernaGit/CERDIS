//
//  SearchedTrasController.swift
//  Rutio
//
//  Created by Kateřina Černá on 31.01.2021.
//

import UIKit
import CoreData
import Alamofire


class SearchedTrasController: UITableViewController {
    
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var planning: PlanningTrasController? {
        didSet{
            loadJsonData()
        }
    }
   /* var planningFavourite: FavouriteController? {
        didSet{
            loadJsonData()
        }
    }*/
    
    @IBAction func cancelSearch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private var jsonFrom: [From] = []
    var nameFrom: String = ""
    var data: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchedTrasView", bundle: Bundle(for: SearchTableViewCell.self)), forCellReuseIdentifier: "SearchedTrasView")

        
        let epochTime = TimeInterval(1429162809359) / 1000
        let date = Date(timeIntervalSince1970: epochTime)   // "Apr 16, 2015, 2:40 AM"

        print("Converted Time \(date)")
        
    }
    
    
    
    func loadJsonData()
    {
        let url = URL(string:"https://api.rutio.eu/otp/routers/zagreb/plan?fromPlace=\(planning?.startDestination.latitude ?? 0.0),\(planning?.startDestination.longitude ?? 0.0)&toPlace=\(planning?.endDestination.latitude ?? 0.0),\(planning?.endDestination.longitude ?? 0.0)&date=2021/07/25&time=11:46&showIntermediateStops=true&maxWalkDistance=300&wheelchair=false&mode=TRANSIT&useRequestedDateTimeInMaxHours=true&optimize=TRANSFERS&walkReluctance=20&min=TRIANGLE&triangleTimeFactor=1&triangleSlopeFactor=0&searchWindow=14400&allowBikeRental=true&arriveBy=false")
        var dataString = "" // starting POST string
        
        // the POST string has entries separated by &
        /*dataString = dataString + "&fromPlace=\(planning.startPlanner.text!)" // add items as name and value
         dataString = dataString + "&toPlace=\(planning.destinationPlanner.text!)"
         dataString = dataString + "&time=\(planning.timeTextField.text!)"
         dataString = dataString + "&date=\(planning.dateTextFiled.text!)"*/
        
        let headers: HTTPHeaders = ["Content-Type" : "application/json; charset=utf-8"]
        //let url = URL(string: "https://api.rutio.eu/otp/routers/zagreb/index/stops/")!
        Alamofire.request(url ?? "", method: .get ,headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                   /* //let dataD = dataString.data(using: .utf8) // convert to utf8 string
                        if let items = data as? [String: Any]{
                        if let plan = items["plan"] as? [String: Any]{
                            if let from = plan["from"] as? [String: Any]{
                                if let name = from["name"] as? String{
                                    //self.jsonFrom = try JSONDecoder().decode(From.self, from: from)
                                    self.nameFrom = from["name"] as! String
                                }
                            }
                        }
                    }*/
                    let parResult = try JSONDecoder().decode(Welcome.self, from: data)
                    print(parResult)
                    self.data.append(parResult.plan)
                    //self.data.append(parResult.plan.to)
                    //self.data.append(parResult.plan.itineraries)

                    print(data)
                    
                    self.tableView.reloadData()
                    print(self.jsonFrom)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getSpecificDateFormat(format: String) -> String {
        return Date().getDateInFormat(format: format)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchedTrasView", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        let item = data[indexPath.row]
        switch item {
        case let from as Plan:
           /* cell.startLabel.text = from.from.name
            cell.numberStartLabel.text = from.itineraries[0].legs[0].routeShortName
            cell.destinationLabel.text = from.to.name
            //cell.numberDestinationLabel.text = from.itineraries[0].legs[0].routeShortName
            cell.walkLabel.text = "Go "+String(from.itineraries[0].walkTime)+" m on foot"
            
            cell.startTime.text = String(from.itineraries[0].startTime)
            cell.destiantionTime.text = String(from.itineraries[0].endTime)*/
            
            cell.commonInit(start: from.from.name, destination: from.to.name, numberStart: from.itineraries[0].legs[0].routeShortName as? Int ?? 0 , timeStart: Int(from.itineraries[0].startTime), timeDestination: from.itineraries[0].endTime , start2: from.itineraries[0].legs[1].from.name, destination2: from.itineraries[0].legs[1].to.name, numberStart2: from.itineraries[0].legs[1].routeShortName as? Int ?? 0, timeStart2: from.itineraries[0].legs[1].startTime , timeDestination2: from.itineraries[0].legs[1].endTime , start3: from.itineraries[0].legs[2].from.name, destination3: from.itineraries[0].legs[2].to.name, numberStart3: from.itineraries[0].legs[2].routeShortName as? Int ?? 0, timeStart3: from.itineraries[0].legs[2].startTime , timeDestination3: from.itineraries[0].legs[2].endTime , walk: "Go "+String(from.itineraries[0].walkDistance)+" m on foot", walk2: "Go "+String(from.itineraries[0].walkDistance)+" m on foot")
            // počet mezizastávek itineraries[0].legs[0].intermediateStops?.count
            return cell

        default:
            fatalError()
        }
        
            //////////////////////////////////// Dokončit!!!!
             /* let legs = "mode"
             switch legs{
             case "BUS": cell.startTrasnsportImage.image = UIImage(named: "ic_bus")
             case "TRAIN": cell.startTrasnsportImage.image = UIImage(named: "ic_train")
             case "TRAM": cell.startTrasnsportImage.image = UIImage(named: "ic_tram")
             
             case "BUS": cell.meziTransportImage.image = UIImage(named: "ic_bus")
             case "TRAIN": cell.meziTransportImage.image = UIImage(named: "ic_train")
             case "TRAM": cell.meziTransportImage.image = UIImage(named: "ic_tram")
                
             case "BUS": cell.destinationTransportImage.image = UIImage(named: "ic_bus")
             case "TRAIN": cell.destinationTransportImage.image = UIImage(named: "ic_train")
             case "TRAM": cell.destinationTransportImage.image = UIImage(named: "ic_tram")
             default: cell.startTrasnsportImage.image = UIImage(named: "ic_bus")
             }*/
    }
    
    
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
extension NSDate {
    func localizedStringTime()->String {
        return DateFormatter.localizedString(from: self as Date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
    }
}


extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

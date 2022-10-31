//
//  Map.swift
//  Rutio
//
//  Created by Tomáš Skála on 18.11.2020.
//

import UIKit
import MapKit
import CoreData
import CoreLocation
import GoogleMaps

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}

class MapController: UIViewController, CLLocationManagerDelegate {

    // @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    var timer = Timer()
    
    @IBOutlet weak var mapViewContainer: UIView!
    // Creates a marker in the center of the map.
    // let marker = GMSMarker()
    // let mapView = GMSMapView()
    
    private var pointJson = [From2]()
    let lat = 49.06
    let lon = 16.35
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        var camera = GMSCameraPosition.camera(withLatitude: 49.2002211, longitude: 16.6078411, zoom: 10.0)
        // Check for Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            
            //Zoom to user location
            if let userLocation = locationManager.location?.coordinate {
                camera = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: 13.0)
            } else {
                camera = GMSCameraPosition.camera(withLatitude: 49.2002211, longitude: 16.6078411, zoom: 10.0)
            }
                        
        }
        
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        
        mapView.isTrafficEnabled = true
        mapView.isMyLocationEnabled = true
        mapView.settings.rotateGestures = false
        
        
        do {
              // Set the map style by passing the URL of the local file.
            if self.traitCollection.userInterfaceStyle == .dark {
                        // User Interface is Dark
                if let styleURL = Bundle.main.url(forResource: "styleDark", withExtension: "json") {
                    mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                  } else {
                    NSLog("Unable to find style.json")
                  }

                    } else {
                        // User Interface is Light
                        if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                          } else {
                            NSLog("Unable to find style.json")
                          }
                    }
            } catch {
              NSLog("One or more of the map styles failed to load. \(error)")
            }
        
        // self.view.addSubview(mapView)
        mapViewContainer.addSubview(mapView)
        
        let now = Date()

            let formatter = DateFormatter()

            formatter.timeZone = TimeZone.current

            formatter.dateFormat = "HHmmss"

            let dateString = formatter.string(from: now)
        
        guard let mapUrl = URL(string: "https://app.goodapps.cz/cedris/getVehicles.php?timestamp=" + dateString) else { return }
        URLSession.shared.dataTask(with: mapUrl) { (data, response, error) in
            
            if error == nil {
                do {
                    self.pointJson = try JSONDecoder().decode([From2].self, from: data!)
                    
                    DispatchQueue.main.async {
                        
                        for state in self.pointJson {
                            print(state.lat, state.lon, state.name)
                            
                            let lat = Double(state.lat)
                            let long = Double(state.lon)
                                
                            let marker = GMSMarker()
                            //let markerText = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: state.lat, longitude: state.lon)
                            //markerText.position = CLLocationCoordinate2D(latitude: state.lat, longitude: state.lon)
                            marker.title = state.name + " ➔ " + state.finalStop                            // marker.setValue(state.vehicle, forKey: "vehicleId")
                            // marker.value(forKey: "id")
                            marker.snippet = "Vůz: " + String(state.vehicle) + " (" + state.company + ")\nSPZ: " + state.SPZ + "\nKurz: " + state.course + "\nZastávka: " + state.lastStop + " (+" + String(state.delay) + " min)"
                            //markerText.title = state.name
                            //markerText.snippet = "Vuz: " + String(state.vehicle) + "\nKurz: " + state.course + "\nZpoždění: " + String(state.delay) + " min"
                            // marker.icon = UIImage(named: String(state.ltype))
                            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                            //markerText.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                            marker.icon = self.createImage(count: state.name, ltype: state.ltype, bearing: state.bearing, lineID: state.lineID)
                            //markerText.icon = self.createImage(count: state.name, ltype: String(state.ltype), bearing: state.bearing)
                            marker.map = mapView
                            //markerText.map = mapView
                            
                        }
                    }
                } catch let jsonError{
                    print("An error occurred + \(jsonError)")
                }
            }
        }.resume()
        
    
        self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
                  
            let now = Date()

                let formatter = DateFormatter()

                formatter.timeZone = TimeZone.current

                formatter.dateFormat = "HHmmss"

                let dateString = formatter.string(from: now)
            
        guard let mapUrl = URL(string: "https://app.goodapps.cz/cedris/getVehicles.php?timestamp=" + dateString) else { return }
        URLSession.shared.dataTask(with: mapUrl) { (data, response, error) in
                        
            if error == nil {
                do {
                    self.pointJson = try JSONDecoder().decode([From2].self, from: data!)
                    
                    DispatchQueue.main.async {
                        
                        mapView.clear()
                        
                        for state in self.pointJson {
                            print(state.lat, state.lon, state.name)
                            
                    
                            let lat = Double(state.lat)
                            let long = Double(state.lon)
                            	
                            let marker = GMSMarker()
                            //let markerText = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: state.lat, longitude: state.lon)
                            //markerText.position = CLLocationCoordinate2D(latitude: state.lat, longitude: state.lon)
                            marker.title = state.name + " ➔ " + state.finalStop
                            // marker.setValue(state.vehicle, forKey: "vehicleId")
                            // marker.value(forKey: "id")
                            marker.snippet = "Vůz: " + String(state.vehicle) + " (" + state.company + ")\nSPZ: " + state.SPZ + "\nKurz: " + state.course + "\nZastávka: " + state.lastStop + " (+" + String(state.delay) + " min)"
                            //markerText.title = state.name
                            //markerText.snippet = "Vůz: " + String(state.vehicle) + "\nKurz: " + state.course + "\nZpoždění: " + String(state.delay) + " min"
                            // marker.icon = UIImage(named: String(state.ltype))
                            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                            //markerText.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                            //marker.icon = UIImage(named: String(state.ltype))
                            //markerText.icon = self.createImage(count: state.name, ltype: String(state.ltype), bearing: state.bearing)
                            marker.icon = self.createImage(count: state.name, ltype: state.ltype, bearing: state.bearing, lineID: state.lineID)
                            marker.zIndex = Int32(state.vehicle)
                            if(marker.zIndex == 7060)
                            {
                                print("Ahoj")
                            }
                            
                            marker.map = mapView
                            //markerText.map = mapView
                            
                        }
                    }
                } catch let jsonError{
                    print("An error occurred + \(jsonError)")
                }
            }
        }.resume()
        
        })
        
        loadStopData()

        // Check for Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            
            //Zoom to user location
            if let userLocation = locationManager.location?.coordinate {
                let camera = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: 14.0)
                        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
            } else {
                
            }
            
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
            
        }
      
      /*
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        // mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        mapView.showsTraffic = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        let homeLocation = CLLocation(latitude: 49.2002211, longitude: 16.6078411)
        centerMapOnLocation(location: homeLocation)
        
        loadStopData()
        
      self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
          self.loadStopData()
      })
     */
        
    }
    
    /*
     func mapView(_ mapView:MKMapView, viewFor annotation:MKAnnotation) -> MKAnnotationView? {
        return NonClusteringMKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMaker")
    }
     */
    
    //count is the integer that has to be shown on the marker
    func createImage(count: String, ltype: Int, bearing: Double, lineID: Int) -> UIImage {

        var color = UIColor.black
        var line = "REG"
        
        if(ltype == 0) {
            
        if(count == "1") {
            line = "1"
            color = UIColor.white
        }
        
        if(count == "2") {
            line = "2"
            color = UIColor.white
        }
        
        if(count == "3") {
            line = "3"
            color = UIColor.white
        }
        
        if(count == "4") {
            line = "4"
            color = UIColor.white
        }
        
        if(count == "5") {
            line = "5"
            color = UIColor.white
        }
        
        if(count == "6") {
            line = "6"
            color = UIColor.white
        }
        
        if(count == "7") {
            line = "7"
            color = UIColor.white
        }
        
        if(count == "8") {
            line = "8"
        }
        
        if(count == "9") {
            line = "9"
            color = UIColor.white
        }
        
        if(count == "10") {
            line = "10"
            color = UIColor.white
        }
        
        if(count == "11") {
            line = "11"
            color = UIColor.white
        }
        
        if(count == "12") {
            line = "12"
            color = UIColor.white
        }
            
        }
        
        do {
            var linka = Int(count) ?? 100
            if(linka > 100 && linka < 110) {
                line = "DALKREG"
                color = UIColor.black
            }
        } catch {
            
        }
        
        if(ltype == 2) {
            line = "MHD"
            color = UIColor.white
        }
        
        if(ltype == 1) {
            line = "TROL"
            color = UIColor.white
        }
        
        if(ltype == 5) {
            line = "VLAK"
            color = UIColor.white
        }
        
        if(ltype == 5) {
            line = "VLAK"
            color = UIColor.white
        }
        
        if(lineID >= 89 && lineID <= 99) {
            line = "NIGHT"
            color = UIColor.yellow
        }
        
        // select needed color
        // let string = "\(UInt(count))"
        let string = count
        // the string to colorize
        let attrs: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        let attrStr = NSAttributedString(string: string, attributes: attrs)
        // add Font according to your need
        var imageBearing = "1"

        if(bearing > 0 && bearing < 23) {
            imageBearing = "1"
        }
        if(bearing > 22 && bearing < 68) {
            imageBearing = "2"
        }
        if(bearing > 67 && bearing < 113) {
            imageBearing = "3"
        }
        if(bearing > 112 && bearing < 158) {
            imageBearing = "4"
        }
        if(bearing > 157 && bearing < 203) {
            imageBearing = "5"
        }
        if(bearing > 202 && bearing < 248) {
            imageBearing = "6"
        }
        if(bearing > 247 && bearing < 293) {
            imageBearing = "7"
        }
        if(bearing > 292 && bearing < 338) {
            imageBearing = "8"
        }
        if(bearing > 337 && bearing < 361) {
            imageBearing = "1"
        }
        if(bearing == -1) {
            imageBearing = "9"
        }
        
        
        let image = UIImage(named: "pin-" + line + "-"+imageBearing)!
        // The image on which text has to be added
        UIGraphicsBeginImageContext(image.size)
        // image.rotate(radians: bearing)
        image.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(image.size.width), height: CGFloat(image.size.height)))
        let rect = CGRect(x: CGFloat(15), y: CGFloat(18), width: CGFloat(image.size.width), height: CGFloat(image.size.height))

        attrStr.draw(in: rect)

        let markerImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return markerImage
    }
        
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: 50000, longitudinalMeters: 50000)
        // mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadStopData(){
        // mapView.removeAnnotations(mapView.annotations)
                
        let now = Date()

            let formatter = DateFormatter()

            formatter.timeZone = TimeZone.current

            formatter.dateFormat = "HHmmss"

            let dateString = formatter.string(from: now)
        
        // guard let mapUrl = URL(string: "https://app.goodapps.cz/autotrolej/new/json.php?timestamp=" + dateString) else { return }
        guard let mapUrl = URL(string: "https://app.goodapps.cz/cedris/getVehicles.php?timestamp=" + dateString) else { return }
        URLSession.shared.dataTask(with: mapUrl) { (data, response, error) in
            
            if error == nil {
                do {
                    self.pointJson = try JSONDecoder().decode([From2].self, from: data!)
                    
                    DispatchQueue.main.async {
                        
                        for state in self.pointJson {
                            print(state.lat, state.lon, state.name)
                            
                            let lat = Double(state.lat)
                            let long = Double(state.lon)
                            
                            //markers work correctly
                            // let annotation = CustomePinAnnotation()
                            /*
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
                            annotation.title = state.name
                            annotation.subtitle = */
                            
                            /*
                            self.marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            self.marker.title = state.name
                            self.marker.snippet = "Kurz: " + state.course
                            self.marker.icon = UIImage(named: "ic_bus")
                            self.marker.map = self.mapView
                            */
                             
                            // self.marker.map = mapView
                            
                            // annotation.pinColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.8)
                            // annotation.pinImage = UIImage(named: "ic_bus")
                            // annotation.image = UIImage(named: "ic_bus")
                                                       
                            // self.mapView.addAnnotation(annotation)
                            
                            // self.mapView.delegate = self
                        }
                    }
                } catch let jsonError{
                    print("An error occurred + \(jsonError)")
                }
            }
        }.resume()
        
    }
        
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors " + error.localizedDescription)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _:CLLocationCoordinate2D = manager.location!.coordinate
        // self.mapView.showsUserLocation = true
        
        // mapView.mapType = MKMapType.standard
        _ = MKPointAnnotation()
        /*
        if locations.last != nil{
            let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            self.mapView.setRegion(region, animated: true)
        }
         */
        // Get user's Current Location and Drop a pin
        let mUserLocation:CLLocation = locations[0] as CLLocation
        _ = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        
        centerMapOnLocation(location: mUserLocation)
        /*let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
         mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
         mkAnnotation.title = "Here you stand"
         mapView.addAnnotation(mkAnnotation)*/
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if mapView.camera.zoom >= 16 {
   
    /*
    guard let mapUrl = URL(string: "https://app.goodapps.cz/cedris/stops.php") else { return }
    URLSession.shared.dataTask(with: mapUrl) { (data, response, error) in
        
        if error == nil {
            do {
                self.stopsJson = try JSONDecoder().decode([Stop].self, from: data!)
                
                DispatchQueue.main.async {
                                        
                    for state in self.stopsJson {
                        print(state.lat, state.lon, state.name)
                        
                        let lat = Double(state.lat)
                        let long = Double(state.lon)
                            
                        let marker = GMSMarker()
                        //let markerText = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: state.lat, longitude: state.lon)
                        //markerText.position = CLLocationCoordinate2D(latitude: state.lat, longitude: state.lon)
                        marker.title = state.name + " ➔ " + state.finalStop
                        // marker.setValue(state.vehicle, forKey: "vehicleId")
                        // marker.value(forKey: "id")
                        marker.snippet = "Zona: " + String(state.vehicle) + " (" + state.company + ")\nSPZ: " + state.SPZ + "\nKurz: " + state.course + "\nZastávka: " + state.lastStop + " (+" + String(state.delay) + " min)"
                        //markerText.title = state.name
                        //markerText.snippet = "Vůz: " + String(state.vehicle) + "\nKurz: " + state.course + "\nZpoždění: " + String(state.delay) + " min"
                        // marker.icon = UIImage(named: String(state.ltype))
                        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        //markerText.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        //marker.icon = UIImage(named: String(state.ltype))
                        //markerText.icon = self.createImage(count: state.name, ltype: String(state.ltype), bearing: state.bearing)
                        marker.icon = self.createImage(count: state.name, ltype: state.ltype, bearing: state.bearing, lineID: state.lineID)
                        marker.map = mapView
                        //markerText.map = mapView
                        
                    }
                }
            } catch let jsonError{
                print("An error occurred + \(jsonError)")
            }
        }
    }.resume()

     */
        } else {
       //     mapView.clear()
        }
    }
        
}

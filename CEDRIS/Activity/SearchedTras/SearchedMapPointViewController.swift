//
//  SearchedMapPointViewController.swift
//  Rutio
//
//  Created by Kateřina Černá on 26.03.2021.
//

import UIKit
import MapKit
import CoreData
import CoreLocation
import Alamofire


class SearchMapPointController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var currentLocationStr = "Current location"
    
    private var pointJson = [From2]()
    var tappedMarker = MKMapView()
    let x = 150.000000 //X
    let y = 35.000000  //Y
    let lat = 45.74
    let lon = 15.95
    var planning: PlanningTrasController? {
        didSet{
            loadJsonData()
        }
    }
    
    var data: [Any] = []
    var myRoute : MKRoute?
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }        // Do any additional setup after loading the view.
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        let homeLocation = CLLocation(latitude: 45.81881, longitude: 15.95882)
        centerMapOnLocation(location: homeLocation)
        loadJsonData()
        
    }
    
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: 30000, longitudinalMeters: 30000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadJsonData()
    {
        let url = URL(string:"https://api.rutio.eu/otp/routers/zagreb/plan?fromPlace=\(planning?.startDestination.latitude ?? 0.0),\(planning?.startDestination.longitude ?? 0.0)&toPlace=\(planning?.endDestination.latitude ?? 0.0),\(planning?.endDestination.longitude ?? 0.0)&date=2021/07/25&time=11:46&showIntermediateStops=true&maxWalkDistance=300&wheelchair=false&mode=TRANSIT&useRequestedDateTimeInMaxHours=true&optimize=TRANSFERS&walkReluctance=20&min=TRIANGLE&triangleTimeFactor=1&triangleSlopeFactor=0&searchWindow=14400&allowBikeRental=true&arriveBy=false")!
        
        
        let headers: HTTPHeaders = ["Content-Type" : "application/json; charset=utf-8"]
        Alamofire.request(url, method: .get ,headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    
                    let parResult = try JSONDecoder().decode(Welcome.self, from: data)
                    print(parResult)
                    //self.data.append(parResult.plan.to)
                    //self.data.append(parResult.plan.itineraries)
                    let lat = Double(parResult.plan.from.lat)
                    let long = Double(parResult.plan.from.lon)
                    let lat2 = Double(parResult.plan.to.lat)
                    let long2 = Double(parResult.plan.to.lon)
                    
                    //markers work correctly
                    let annotation = CustomePinAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
                    annotation.title = parResult.plan.from.name
                    annotation.subtitle = parResult.plan.itineraries[0].legs[0].routeShortName
                    annotation.pinImage = "pin"
                    annotation.pinColor = UIColor.red
                    self.mapView.addAnnotation(annotation)
                    
                    let annotation2 = CustomePinAnnotation()
                    annotation2.coordinate = CLLocationCoordinate2DMake(lat2, long2)
                    annotation2.title = parResult.plan.to.name
                    annotation2.subtitle = parResult.plan.itineraries[0].legs[0].routeShortName
                    annotation2.pinImage = "pin"
                    self.mapView.addAnnotation(annotation2)
                    self.mapView.delegate = self
                    
                    
                    let points = [CLLocationCoordinate2DMake(lat, long), CLLocationCoordinate2DMake(lat2, long2)]
                    let geodesic = MKGeodesicPolyline(coordinates: points, count: 2)
                    self.mapView.addOverlay(geodesic)                    
                    
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
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
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.mapView.showsUserLocation = true
        
        mapView.mapType = MKMapType.standard
        let annotation = MKPointAnnotation()
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            self.mapView.setRegion(region, animated: true)
        }
        // Get user's Current Location and Drop a pin
        let mUserLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
    }
    
    
    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)
        
        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
            
            if let mPlacemark = placemarks{
                if let dict = mPlacemark[0].addressDictionary as? [String: Any]{
                    if let Name = dict["Name"] as? String{
                        if let City = dict["City"] as? String{
                            self.currentLocationStr = Name + ", " + City
                        }
                    }
                }
            }
        }
        return currentLocationStr
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: routePolyline)
                renderer.strokeColor = UIColor.red
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer()
    }
}

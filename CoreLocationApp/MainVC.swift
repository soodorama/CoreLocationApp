//
//  ViewController.swift
//  CoreLocationApp
//
//  Created by Neil Sood on 9/13/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol DescVCDelegate: class {
    func removeMarker(by controller: DescVC, with data: Bool)
}

class MainVC: UIViewController {
    
    @IBOutlet weak var coordLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var quikFitButton: UIButton!
    
    let locationManager = CLLocationManager()
    var startLoc: CLLocationCoordinate2D?
    
    var chosenLat: Double = 37.374291
    var chosenLong: Double = 37.374291
    
    var hardcoded_stop = false
    
    let marker = Marker(title: "Coding Dojo",
                        subtitle: "1920 Zanker Road, San Jose, CA",
                        coordinate: CLLocationCoordinate2D(latitude: 37.375291, longitude: -121.910585))
    
    let marker2 = Marker(title: "Cross Fit 101",
                         subtitle: "279 E Brokaw Rd, San Jose, CA",
                         coordinate: CLLocationCoordinate2D(latitude: 37.377631, longitude: -121.913670))
    
    let marker3 = Marker(title: "24 Hour Fitness",
                         subtitle: "1610 Crane St, San Jose, CA",
                         coordinate: CLLocationCoordinate2D(latitude: 37.371369, longitude: -121.910923))
    
    var geofenceRegionCenter: CLLocationCoordinate2D?
    
    var geofenceRegion: CLCircularRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Your coordinates go here (lat, lon)
        geofenceRegionCenter = CLLocationCoordinate2D(
            latitude: 37.375291,
            longitude: -121.910585
        )
        
        geofenceRegion = CLCircularRegion(
            center: geofenceRegionCenter!,
            radius: 50,
            identifier: "UniqueIdentifier"
        )
        
        geofenceRegion?.notifyOnEntry = true
        geofenceRegion?.notifyOnExit = true
        
        self.locationManager.startMonitoring(for: geofenceRegion!)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        quikFitButton.layer.cornerRadius = 10
        quikFitButton.clipsToBounds = true
        
        
        mapView.addAnnotation(marker)
        mapView.addAnnotation(marker2)
        mapView.addAnnotation(marker3)
    }
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let descVC = navigationController.topViewController as! DescVC
        descVC.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if hardcoded_stop {
            mapView.removeAnnotation(marker)
        }
    }
    
    
    @IBAction func getFitPressed(_ sender: UIButton) {
        print("lat: \(locationManager.location?.coordinate.latitude) long: \(locationManager.location?.coordinate.longitude)")
        if !(geofenceRegion?.contains((locationManager.location?.coordinate)!))! {
            let alert = UIAlertController(title: "No FitQuik Location Nearby", message: "Go to a FitQuik location on the map", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if !hardcoded_stop {
            performSegue(withIdentifier: "ARSegue", sender: nil)
        }
        else {
//            hardcoded_stop = true
            let alert = UIAlertController(title: "Let's Go", message: "Get active at another FitQuik location", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        annotationView.image = UIImage(named:"map_pin_medium")
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

class Marker: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    var imageName: String = "map_pin"
}

extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        coordLabel.text = "locations = \(locValue.latitude) \(locValue.longitude)"
        if startLoc?.latitude == nil {
//            print("hi")
            startLoc?.latitude = locValue.latitude
            startLoc?.longitude = locValue.longitude
        }
    }
}

extension MainVC: DescVCDelegate {
    func removeMarker(by controller: DescVC, with data: Bool) {
        hardcoded_stop = data
        dismiss(animated: true, completion: nil)
    }
    
}


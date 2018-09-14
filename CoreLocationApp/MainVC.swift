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

class MainVC: UIViewController {
    
    @IBOutlet weak var coordLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var quikFitButton: UIButton!
    
    let locationManager = CLLocationManager()
    var startLoc: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Your coordinates go here (lat, lon)
        let geofenceRegionCenter = CLLocationCoordinate2D(
            latitude: 37.376,
            longitude: -121.911
        )
        
        let geofenceRegion = CLCircularRegion(
            center: geofenceRegionCenter,
            radius: 20,
            identifier: "UniqueIdentifier"
        )
        
        geofenceRegion.notifyOnEntry = true
        geofenceRegion.notifyOnExit = true
        
        self.locationManager.startMonitoring(for: geofenceRegion)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        quikFitButton.layer.cornerRadius = 10
        quikFitButton.clipsToBounds = true
        
        
//        print("\(startLoc?.latitude)" + " - " + "\(startLoc?.longitude)")
        
//        view.backgroundColor = UIColor.gray
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    
    @IBAction func getFitPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ARSegue", sender: nil)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "map_pin")
        }
        
        return annotationView
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


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


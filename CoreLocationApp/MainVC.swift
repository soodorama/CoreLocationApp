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
    
    let locationManager = CLLocationManager()
    var startLoc: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        print("\(startLoc?.latitude)" + " - " + "\(startLoc?.longitude)")
        
        view.backgroundColor = UIColor.gray
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}


extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        coordLabel.text = "locations = \(locValue.latitude) \(locValue.longitude)"
        if startLoc?.latitude == nil {
//            print("hi")
            startLoc?.latitude = locValue.latitude
            startLoc?.longitude = locValue.longitude
        }
    }
}


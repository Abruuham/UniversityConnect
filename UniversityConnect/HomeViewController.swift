//
//  HomeViewController.swift
//  UniversityConnect
//
//  Created by Abraham Calvillo on 2/14/21.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBottomSheetView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        
        
    }
    
    func addBottomSheetView(){
        let bottomSheetVC = BottomSheetViewController()
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        
        let height = view.frame.height
        let width = view.frame.width
        
        bottomSheetVC.view.frame = CGRect(x: 0.0, y: view.frame.maxY, width: width, height: height)
    }
    
    //MARK: - Map Settings
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        locationManager.stopUpdatingLocation()
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        // CBU coordinates 33.9289, 117.4259
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
    }

}

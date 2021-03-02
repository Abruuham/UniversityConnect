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
import Firebase
import FirebaseFirestore


class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var annotation: MKAnnotation!
    var pointAnnotation:MKPointAnnotation!
    var pinView:MKPinAnnotationView!
    var region: MKCoordinateRegion!
    var names: [Coordinates] = []
    
    
    let locationManager = CLLocationManager()
    private let db = Firestore.firestore()
    private var reference: CollectionReference?

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
        
        
        getPlaces()
        
        
    }
    
    func getPlaces(){
        db.collection("chat").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID.uppercased())")
                    let data = document.data()
                    print(document["latitude"]!)
                    print(document["longitude"]!)
                    
                    self.addPinOnMap(lat: "\(document["latitude"]!)", long: "\(data["longitude"]!)", locationTitle: "\(document.documentID.uppercased())")
                }
            }
        }
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
    
    
    func addPinOnMap(lat: String, long: String, locationTitle: String){
        
//        if map.annotations.count != 0 {
//            annotation = map.annotations[0]
//            map.removeAnnotation(annotation)
//        }
//        
//        
        /// Add PointAnnotation text and a pin to the map
        pointAnnotation = MKPointAnnotation()
        self.pointAnnotation.title = locationTitle
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: (lat as NSString).doubleValue, longitude: (long as NSString).doubleValue)
        
        pinView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
        map.addAnnotation(self.pinView.annotation!)
        
        
        let coordinate = CLLocationCoordinate2DMake((lat as NSString).doubleValue, (long as NSString).doubleValue)

        let regionRadius = 50.0
        let circle = MKCircle(center: coordinate, radius: regionRadius)
        map.addOverlay(circle)
        
        
        map.reloadInputViews()
        
    }
    
    // Function to allow for custom pin image.
    // Uncomment to use custom pin otherwise it will use apple default pins
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation.isKind(of: MKPointAnnotation.self){
//            let reuseID = "CustomPinAnnotationView"
//            var annotationView = map.dequeueReusableAnnotationView(withIdentifier: reuseID)
//
//            if annotationView == nil{
//                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
//                annotationView!.canShowCallout = false
//
//                /// Custom pin image
//                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//                imageView.image = UIImage(named: "marker.png")
//                imageView.center = annotationView!.center
//                imageView.contentMode = .scaleAspectFill
//                annotationView!.addSubview(imageView)
//
//            }
//
//            return annotationView
//        }
//
//        return nil
//    }
    
    // Function that shows a geofence radiius around the pinned location
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.strokeColor = UIColor.red
            circleRenderer.lineWidth = 1.0
            return circleRenderer
        }
    
    

}

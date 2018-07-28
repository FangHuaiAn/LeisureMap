//
//  MapViewController.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/25.
//  Copyright © 2018年 tripim. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    // Location
    
    let locationManager = CLLocationManager()
    
    
    let regionRadius : CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        //
        let flag = MapFlag(
            title: "iOS App by Swift",
            locationName: "ABC",
            discipline: "Apple Room",
            coordinate: CLLocationCoordinate2D(
                latitude: 31.29065118,
                longitude: 118.3623587),
            url: "https://apple.com")
        
        mapView.addAnnotation(flag)
        //
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? MapFlag else{
            return nil
        }
        
        let identifier = "marker"
        let annotationView  : MKAnnotationView
        
        
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeueView.annotation = annotation
            annotationView = dequeueView
        }else{
            
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            annotationView.calloutOffset = CGPoint( x: -5, y: 5)
            
            let button = UIButton(type: .detailDisclosure)
            
            annotationView.rightCalloutAccessoryView = button
            
            button.addTarget(self, action: #selector(self.moveToWebView(sender:)), for: .touchUpInside)
            
        }
        
        
        return annotationView
        
    }
    
    func centerMapOnLocation( location : CLLocation )  {
        
        let  coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue : CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        print("latitude:\( locValue.latitude ):longitude:\( locValue.longitude )")
        
        centerMapOnLocation(location: manager.location! )
        
    }
    
    @objc func moveToWebView( sender : UIButton ){
        print("moveToWebView")
    }


}

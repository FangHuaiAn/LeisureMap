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
    
    
    let regionRadius : CLLocationDistance = 10000
    
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
            title: "客製化圖標",
            locationName: "熱帶植物園",
            description: "位於墾丁的熱帶植物園",
            coordinate: CLLocationCoordinate2D(
                latitude: 21.97,
                longitude: 120.81),
            url: "https://www.ktnp.gov.tw/Default.aspx")
        
        mapView.addAnnotation(flag)
        
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
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "moveToWebViewSegue", sender: self)
        }
        
        
    }


}

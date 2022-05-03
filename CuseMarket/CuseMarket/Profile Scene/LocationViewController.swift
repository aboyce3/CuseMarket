//
//  LocationViewController.swift
//  CuseMarket
//
//  Created by Zhiyi Chen on 4/30/22.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var customRadius: UILabel!
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest // impact on battery
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first { // locations is an array of user's locations
            manager.stopUpdatingLocation()
            
            render(location, span: 0.1)
        }
    }
    
    func render(_ location: CLLocation, span: Double) {
        // zoom in
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        let value = sender.value
        let string = String(format: "%.1f", value)
        customRadius.text = "\(string) miles"
    }
    
    @IBAction func applyDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

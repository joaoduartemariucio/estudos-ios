//
//  ViewController.swift
//  Mapbox Samples
//
//  Created by João Vitor Duarte Mariucio on 29/07/20.
//  Copyright © 2020 João Vitor Duarte Mariucio. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate {
    
    let point = MGLPointAnnotation()
    
    let mapView: MGLMapView = {
        let map = MGLMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        map.styleURL = MGLStyle.darkStyleURL
        map.userTrackingMode = .followWithHeading
        map.showsUserHeadingIndicator = true
        return map
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mapView.delegate = self
        
        let positionMap = CLLocationCoordinate2D(latitude: -22.2211828, longitude: -49.9593675)
        
        mapView.setCenter(positionMap, zoomLevel: 10, direction: 0, animated: false)
        
        point.coordinate = positionMap
        point.title = "McDonald's"
        mapView.addAnnotation(point)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        //        Efeito de abertura do mapa
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, altitude: 3800, pitch: 20, heading: 180)
        mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
            
            // Set the annotation view’s background color to a value determined by its longitude.
            let hue = CGFloat(annotation.coordinate.longitude) / 100
            annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


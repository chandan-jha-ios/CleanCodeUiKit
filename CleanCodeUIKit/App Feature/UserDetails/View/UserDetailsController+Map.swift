//
//  UserDetailsController+Map.swift
//  CleanCodeUIKit
//
//  Created by Chandan Jha on 25/08/22.
//

import Foundation
import MapKit

extension UserDetailsController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func showUserPin() {
        guard let user = viewModel?.user,
              let latitude = user.latitude,
              let longitude = user.longitude else { return }
        let pin = MKPointAnnotation()
        pin.title = user.name
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
    }
}

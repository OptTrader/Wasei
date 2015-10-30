//
//  MapViewController.swift
//  Wasei
//
//  Created by Chris Kong on 10/26/15.
//  Copyright © 2015 Chris Kong. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate
{
  @IBOutlet weak var mapView: MKMapView!
  
  var place: Place!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Convert address to coordinate and annotate it on map
    let geoCoder = CLGeocoder()
    geoCoder.geocodeAddressString(place.address, completionHandler: { placemarks, error in
      if error != nil
      {
        print(error)
        return
      }
      if let placemarks = placemarks
      {
        // Get the first placemark
        let placemark = placemarks[0]
        
        // Add annotation
        let annotation = MKPointAnnotation()
        annotation.title = self.place.name
        annotation.subtitle = self.place.type
        
        if let location = placemark.location
        {
          annotation.coordinate = location.coordinate
          
          // Display the annotation
          self.mapView.showAnnotations([annotation], animated: true)
          self.mapView.selectAnnotation(annotation, animated: true)
        }
      }
    })
    
    // Map customization
    mapView.showsCompass = true
    mapView.showsScale = true
    mapView.showsTraffic = true
    mapView.showsPointsOfInterest = true
    mapView.showsBuildings = true
    
    // Set the MKMapViewDelegate
    mapView.delegate = self
  }
  
  // MARK: - MKMapViewDelegate methods
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
  {
    let identifier = "MyPin"
    
    if annotation.isKindOfClass(MKUserLocation)
    {
      return nil
    }
    
    // Reuse the annotation if possible
    var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
    
    if annotationView == nil
    {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView?.canShowCallout = true
    }
    
    let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
    leftIconView.image = UIImage(data: place.image!)
    annotationView?.leftCalloutAccessoryView = leftIconView
    
    // Pin color customization
    annotationView?.pinTintColor = UIColor(red: 246.0/255.0, green: 116.0/255.0, blue: 47.0/255.0, alpha: 1.0)
    
    return annotationView
  }
  
}
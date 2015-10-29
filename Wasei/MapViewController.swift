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
    
    mapView.delegate = self
    mapView.showsCompass = true
    mapView.showsScale = true
    mapView.showsTraffic = true
    mapView.showsPointsOfInterest = true
    mapView.showsBuildings = true
    
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
    
  }
  
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
    annotationView?.pinTintColor = UIColor.blueColor()
    
    return annotationView
  }
  
}
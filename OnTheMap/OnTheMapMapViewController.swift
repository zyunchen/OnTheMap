//
//  OnTheMapMapViewController.swift
//  OnTheMap
//
//  Created by zhangyunchen on 15/12/6.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

import UIKit
import MapKit

class OnTheMapMapViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var onTheMapClient:OnTheMapClient = OnTheMapClient.sharedInstance()
    
    override func viewDidLoad() {
        onTheMapClient.doGetLists { () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.setAnnotations()
            }
            
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        onTheMapClient.doGetLists { () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.setAnnotations()
            }
        }
    }
    
    @IBAction func setLocation(sender: AnyObject) {
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    func setAnnotations(){
//        mapView.removeAnnotations(mapView.annotations)
        var annotations = [MKPointAnnotation]()
        for student in onTheMapClient.newStudents {
            let lat = CLLocationDegrees(student.latitude )
            let long = CLLocationDegrees(student.longitude )
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        mapView.addAnnotations(annotations)

    }
    
   

}

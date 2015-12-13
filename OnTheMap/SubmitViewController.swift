//
//  SubmitViewController.swift
//  OnTheMap
//
//  Created by zhangyunchen on 15/12/13.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SubmitViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    @IBAction func DoneCloseKeyBoard(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func didSearchLocation(sender: UIButton) {
        mapView.hidden = false
        label1.hidden = true
        label2.hidden = true
        label3.hidden = true
        urlTextField.hidden = false
       
        locationEncode(locationTextField.text!,complete:{(loc) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                let annotation = MKPointAnnotation()
                annotation.coordinate = loc
                self.mapView.addAnnotation(annotation)
                self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(loc, 15000, 15000), animated: true)
            }
        })
        
        
        
    }

    @IBAction func didCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.hidden = true
        label1.hidden = false
        label2.hidden = false
        label3.hidden = false
        urlTextField.hidden = true
        self.addKeyboardDismissRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.superview?.frame.origin.y = 0.0
        self.removeKeyboardDismissRecognizer()
    }
    
    //form loaction to longitude and latitude
    func locationEncode(location:String,complete:(loc:CLLocationCoordinate2D) -> Void ) {
        let geocoder = CLGeocoder()
        var p:CLPlacemark!
        
        geocoder.geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:NSError?) -> Void in
            if error != nil {
                //                self.textView.text = "错误：\(error.localizedDescription))"
                //                return
            }
            if let pm = placemarks {
                if pm.count > 0{
                    p = placemarks![0]
                    complete(loc: (p.location?.coordinate)!)
                } else {
                    print("No placemarks!")
                }
            }
            
        }
        
    }

}

// MARK: - SubmitViewController (Show/Hide Keyboard)

extension SubmitViewController {
    
    func addKeyboardDismissRecognizer() {
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
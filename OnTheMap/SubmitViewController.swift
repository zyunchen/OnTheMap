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
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    var onTheMapClient:OnTheMapClient = OnTheMapClient.sharedInstance()
    var loc:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    @IBAction func DoneCloseKeyBoard(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func didSearchLocation(sender: UIButton) {
        if locationTextField.text!.isEmpty{
            showAlert("ERROR", message: "Enter a location")
            return
        }
        
        activityIndicator.startAnimating()
        locationEncode(locationTextField.text!,complete:{(loc,errorString) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                
                guard errorString == nil else{
                    self.showAlert("error", message: errorString)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = loc!
                self.loc = loc
                print("loc is \(loc)")
                self.mapView.addAnnotation(annotation)
                self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(loc!, 15000, 15000), animated: true)
                self.activityIndicator.stopAnimating()
                self.mapView.hidden = false
                self.label1.hidden = true
                self.label2.hidden = true
                self.label3.hidden = true
                self.urlTextField.hidden = false
                self.submitButton.hidden = false
            }
        })
        
        
        
    }

    @IBAction func didCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didSubmit(sender: UIButton) {
        guard let loc = loc else{
            showAlert("error", message: "there is no info about location")
            return
        }
        
        guard var student = onTheMapClient.currentStudent else{
            self.showAlert("error", message: "invalid student data")
            return
        }
        
        student.latitude = loc.latitude
        student.longitude = loc.longitude
        student.mediaURL = urlTextField.text!
        
        print(student)
        
        if let uniqueKey = student.uniqueKey,firstName = student.firstName,lastName = student.lastName,mapString = student.mapString,mediaURL = student.mediaURL,latitude = student.latitude,
            longtitude = student.longitude{
                let body = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longtitude)}"
                print("body is \(body)")
                onTheMapClient.taskForPostMethod(OnTheMapClient.Server.PARSE,method: OnTheMapClient.Methods.GetSession, body: body, completionHandler: { (result, error) -> Void in
                    
                    guard result != nil else{
                        self.showAlert("error", message: error)
                        return
                    }
                    
                    print(result)
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
    
        }
        
    }
    
    //Shows alert and stops activity indicator
    func showAlert(title: String? , message: String?) {
        dispatch_async(dispatch_get_main_queue()){
            if title != nil && message != nil {
                let errorAlert =
                UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                errorAlert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(errorAlert, animated: true, completion: nil)
            }
        }
    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.hidden = true
        label1.hidden = false
        label2.hidden = false
        label3.hidden = false
        urlTextField.hidden = true
        submitButton.hidden = true
        self.addKeyboardDismissRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.superview?.frame.origin.y = 0.0
        self.removeKeyboardDismissRecognizer()
    }
    
    //form loaction to longitude and latitude
    func locationEncode(location:String,complete:(loc:CLLocationCoordinate2D?,errorString:String?) -> Void ) {
        let geocoder = CLGeocoder()
        var p:CLPlacemark!
        
        geocoder.geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:NSError?) -> Void in
            print(placemarks)
            if error != nil {
                complete(loc: nil, errorString:"can not find the place,please try again")
                return
            }
            if let pm = placemarks {
                if pm.count > 0{
                    p = pm.first!
                    print(p)
                    if let country = p.country,state = p.administrativeArea{
                        if let city = p.locality{
                            self.onTheMapClient.currentStudent?.mapString = "\(city),\(state),\(country)"
                        }else{
                            self.onTheMapClient.currentStudent?.mapString = "\(state),\(country)"
                        }
                        complete(loc: (p.location?.coordinate),errorString: nil)
                    }else{
                       complete(loc: nil, errorString: "can not find the place,please try again")
                    }
                    
                } else {
                    print("No placemarks!")
                    complete(loc: nil, errorString: "can not find the place,please try again")
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
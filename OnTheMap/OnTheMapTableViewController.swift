//
//  OnTheMapTableViewController.swift
//  OnTheMap
//
//  Created by zhangyunchen on 15/12/5.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

import UIKit

class OnTheMapTableViewController: UITableViewController {
    
    var onTheMapClient:OnTheMapClient = OnTheMapClient.sharedInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doGetLists()
    }
    @IBAction func refresh(sender: UIBarButtonItem) {
        doGetLists()
    }
    
    func doGetLists(){
        onTheMapClient.doGetLists { (errorString) -> Void in
            if let errorString = errorString {
                self.showAlert("Error", message:errorString)
            }else{
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        }

    }
    
    @IBAction func didLogout(sender: UIBarButtonItem) {
        onTheMapClient.taskForDeleteMethod(OnTheMapClient.Methods.GetSession) { (result, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    //MARK: - Helper Methods
    
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
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Students.sharedInstance().students.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = Students.sharedInstance().students[indexPath.row].firstName! + " " + Students.sharedInstance().students[indexPath.row].lastName!
        cell.detailTextLabel?.text = Students.sharedInstance().students[indexPath.row].mediaURL
        cell.imageView?.image = UIImage(named: "pin")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(NSURL(string:Students.sharedInstance().students[indexPath.row].mediaURL!)!)
    }
    
    
}

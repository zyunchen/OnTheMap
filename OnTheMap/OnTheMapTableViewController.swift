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
        onTheMapClient.doGetLists { () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }

        }
    }
    @IBAction func refresh(sender: UIBarButtonItem) {
        onTheMapClient.doGetLists { () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
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
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return onTheMapClient.newStudents.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = onTheMapClient.newStudents[indexPath.row].firstName + " " + onTheMapClient.newStudents[indexPath.row].lastName
        cell.detailTextLabel?.text = onTheMapClient.newStudents[indexPath.row].mediaURL
        cell.imageView?.image = UIImage(named: "pin")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(NSURL(string: onTheMapClient.newStudents[indexPath.row].mediaURL)!)
    }
    
    
}

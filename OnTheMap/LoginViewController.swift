//
//  ViewController.swift
//  OnTheMap
//
//  Created by zhangyunchen on 15/11/26.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    var backgroundGradient: CAGradientLayer? = nil
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    var onTheMapClient:OnTheMapClient = OnTheMapClient.sharedInstance()
    
    
    
    // MARK: Login
    @IBAction func doLogin(sender: AnyObject) {
//        if email.text!.isEmpty {
//            debugLabel.text = "Username Empty."
//        } else if password.text!.isEmpty {
//            debugLabel.text = "Password Empty."
//        } else {
//            let body = "{\"udacity\": {\"username\": \"\(email.text!)\", \"password\": \"\(password.text!)\"}}"
            let body = "{\"udacity\": {\"username\": \"zh.yunchen@gmail.com\", \"password\": \"asdfqwert\"}}"
            let parameters : [String:AnyObject]? = ["test" : "nothing"]
            onTheMapClient.taskForPostMethod(OnTheMapClient.Methods.GetSession, body: body,parameters: parameters!, completionHandler: { (result, error) -> Void in
                print(result)
                /* GUARD: Is the "session" key in parsedResult? */
                guard let session = result["session"] as? [String : AnyObject] else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.debugLabel.text = "Login Failed (check your password and email)."
                    }
                    print("Cannot find key 'session' in \(result)")
                    return
                }
                
                guard let account = result["account"] as? [String : AnyObject] else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.debugLabel.text = "Login Failed (check your password and email)."
                    }
                    print("Cannot find key 'session' in \(result)")
                    return
                }
                
                print("session is \(session)")
                
                /* 6. Use the data! */
//                self.appDelegate.session = session["id"] as? String
                self.onTheMapClient.loginSession.id = (session["id"] as? String)!
                self.onTheMapClient.loginAccount.key = (account["key"] as? String)!
//                print("session is \(self.appDelegate.session)")
                self.completeLogin()
            })
//        }
        
    }
    
    // MARK: Sign Up
    @IBAction func doSignUp(sender: AnyObject) {
        self.debugLabel.text = ""
//        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
        onTheMapClient.openUrl("sdfsdf")
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugLabel.text = ""
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("homeTabbarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
        
        /* Configure the UI */
        self.configureUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.superview?.frame.origin.y = 0.0
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }
    
}

// MARK: - LoginViewController (Configure UI)

extension LoginViewController {
    
    func configureUI() {
        
        /* Configure background gradient */
        self.view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 244/255, green: 129/255, blue: 25/255, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 253/255, green: 118/255, blue: 35/255, alpha: 1.0).CGColor
        self.backgroundGradient = CAGradientLayer()
        self.backgroundGradient!.colors = [colorTop, colorBottom]
        self.backgroundGradient!.locations = [0.0, 1.0]
        self.backgroundGradient!.frame = view.frame
        self.view.layer.insertSublayer(self.backgroundGradient!, atIndex: 0)
        
        /* Configure header text label */
        headerTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        headerTextLabel.textColor = UIColor.whiteColor()
        
        /* Configure email textfield */
        let emailTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let emailTextFieldPaddingView = UIView(frame: emailTextFieldPaddingViewFrame)
        email.leftView = emailTextFieldPaddingView
        email.leftViewMode = .Always
        email.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        email.backgroundColor = UIColor(red: 244/255, green: 229/255, blue: 235/255, alpha:1.0)
        email.textColor = UIColor(red: 253/255, green: 118/255, blue: 35/255, alpha: 1.0)
        email.attributedPlaceholder = NSAttributedString(string: email.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        email.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        /* Configure password textfield */
        let passwordTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let passwordTextFieldPaddingView = UIView(frame: passwordTextFieldPaddingViewFrame)
        password.leftView = passwordTextFieldPaddingView
        password.leftViewMode = .Always
        password.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        password.backgroundColor = UIColor(red: 244/255, green: 229/255, blue: 235/255, alpha:1.0)
        password.textColor = UIColor(red: 253/255, green: 118/255, blue: 35/255, alpha: 1.0)
        password.attributedPlaceholder = NSAttributedString(string: password.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        password.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        /* Configure debug text label */
        headerTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
        headerTextLabel.textColor = UIColor.whiteColor()
        
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        
    }
}

// MARK: - LoginViewController (Show/Hide Keyboard)

extension LoginViewController {
    
    func addKeyboardDismissRecognizer() {
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if(view.superview?.frame.origin.y == 0.0){
            view.superview?.frame.origin.y -= getKeyboardHeight(notification) / 2
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.superview?.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}



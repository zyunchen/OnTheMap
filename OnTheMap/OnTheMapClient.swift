//
//  ApiManager.swift
//  OnTheMap
//
//  Created by zhangyunchen on 15/12/3.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

import Foundation
import UIKit

class OnTheMapClient : NSObject {
    
    // MARK: Properties
    
    /* Shared session */
    var session: NSURLSession
    
    var loginSession: Session
    
    var loginAccount:Account
    

    

    
    struct Session {
        var expiration:String = ""
        var id:String = ""
    }
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        loginSession = Session()
        loginAccount = Account()
        super.init()
    }
    
    
    // MARK: - API Request Methods
    
    func loginWith(email: String, password: String, completionHandler: (result: AnyObject!, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.BaseUrl + Methods.GetSession)! )
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\" : {\"username\" : \"\(email)\", \"password\" : \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            if let error = error  {
                completionHandler(result: nil, errorString: error.localizedDescription)
                return
            }
            if let data = data {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                self.parseLoginRequest(data: newData, completionHandler: completionHandler)
            } else {
                completionHandler(result: nil, errorString: "Login Error: Unable to retrieve data")
            }
        }; task.resume()
    }
    
    
    
    // MARK: POST
    
    func taskForPostMethod(server:Int,method: String,body: String, completionHandler: (result: AnyObject!, errorString: String?) -> Void) -> NSURLSessionDataTask {
        
        var urlString:String
        if server == Server.UDACITY {
            urlString = Constants.BaseUrl + method
        }else{
            urlString = Constants.ParseBaseUrl + method
        }
        let url = NSURL(string: urlString)!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        if server == Server.UDACITY {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }else{
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(result: nil, errorString:error?.description)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    completionHandler(result: nil, errorString: "get data failed")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    completionHandler(result: nil, errorString: "get data failed")
                } else {
                    completionHandler(result: nil, errorString: "get data failed")
                    print("Your request returned an invalid response!")
                }
                completionHandler(result: nil, errorString: "get data failed")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(result: nil, errorString: "get data failed")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if server == Server.UDACITY {
                OnTheMapClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }else{
                OnTheMapClient.parseOneJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: PUT
    
    func taskForPUTMethod(method: String,body: String, completionHandler: (result: AnyObject!, errorString: String?) -> Void) -> NSURLSessionDataTask {
        
        var urlString:String
        urlString = Constants.ParseBaseUrl + method
        let url = NSURL(string: urlString)!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        
        
        
        
        
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                completionHandler(result: nil, errorString: "get data failed")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */

            OnTheMapClient.parseOneJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    
    // MARK: DELETE
    
    func taskForDeleteMethod(method: String, completionHandler: (result: AnyObject!, errorString: String?) -> Void) -> NSURLSessionDataTask {
        
        
        
        //        /* 1. Set the parameters */
        //        let methodParameters = [
        //            "username": "",
        //            "password":""
        //        ]
        
        /* 2. Build the URL */
        let urlString = Constants.BaseUrl + method
        let url = NSURL(string: urlString)!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! as [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }

            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            OnTheMapClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        task.resume()
        
        return task
    }

    
    // MARK: GET
    
    func taskForGetMethod(method: String, completionHandler: (result: AnyObject!, errorString: String?) -> Void) -> NSURLSessionDataTask {
        
        
        
        //        /* 1. Set the parameters */
        //        let methodParameters = [
        //            "username": "",
        //            "password":""
        //        ]
        
        /* 2. Build the URL */
        let urlString = Constants.ParseBaseUrl + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        /* 3. Configure the request */
        
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(result: nil, errorString: error?.localizedDescription)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                completionHandler(result: nil, errorString: "get data failed")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            OnTheMapClient.parseOneJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func doGetLists(completionHandler: (errorString:String?) -> Void){
        
        taskForGetMethod(OnTheMapClient.Methods.GetStudentLocation) { (result, error) -> Void in
            
            guard let result = result else{
                completionHandler(errorString:error)
                return
            }
            
            /* GUARD: Is the "results" key in parsedResult? */
            guard let students = result["results"] as? [[String:AnyObject]] else {
                dispatch_async(dispatch_get_main_queue()) {
                    print("failed")
                }
                print("Cannot find key 'results' in \(result)")
                completionHandler(errorString: "get data failed")
                return
            }
            
            Students.sharedInstance().students.removeAll()
            
            for student in students {
                let newstudent:Student = Student(dictionary: student)
                Students.sharedInstance().students.append(newstudent)
                
            }
            completionHandler(errorString: nil)
            
        }
        
        
    }
    
    func openUrl(url:String){
        let app = UIApplication.sharedApplication()
        if let nsurl = NSURL(string: url) {
            print("begin to open \(nsurl)")
            app.openURL(nsurl)
        }
    }
    
    


    
    /* Helper: Given raw JSON, return a usable Foundation object, this method is only for udacity login api */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, errorString: String?) -> Void) {
        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            completionHandler(result: nil, errorString: "parse data failed")
        }
        
        completionHandler(result: parsedResult, errorString: nil)
    }
    
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseOneJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, errorString: String?) -> Void) {
//        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            completionHandler(result: nil, errorString :"parse data failed")
        }
        
        completionHandler(result: parsedResult, errorString: nil)
    }
    
    
    // MARK: - Helper Methods
    
    func parseLoginRequest(data data: NSData, completionHandler: (result: AnyObject!, errorString: String?) -> Void) {
        do{
            let parsedData =
            try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            
            print("in parse login request parsedData is \(parsedData)")
            
            if let parsedData = parsedData {
                if let errorString = parsedData["error"] as? String {
                    completionHandler(result: nil, errorString: errorString)
                    return
                }
                if let newParsedData = parsedData["account"] as? [String: AnyObject] {
                    if let hasAccount = newParsedData["registered"] as? Bool{
                        if hasAccount == true {
                            if let _ = newParsedData["key"] as? String, _ = newParsedData["registered"] as? Bool {
                                completionHandler(result: parsedData, errorString: nil)
                            } else {
                                completionHandler(result: nil, errorString: "Unable to login")
                            }
                        } else {
                            completionHandler(result: nil, errorString: "User does not have Udacity account")
                        }
                    } else {
                        completionHandler(result: nil, errorString:"Unable to verify registration") }
                } else {
                    completionHandler(result: nil, errorString:"Account not found")
                }
            } else {
                completionHandler(result: nil, errorString: "Login Error: Unable to parse data")
            }
        } catch let error as NSError{
            completionHandler(result: nil, errorString: "Login Error: \(error.localizedDescription)")
        }
    }

    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> OnTheMapClient {
        
        struct Singleton {
            static var sharedInstance = OnTheMapClient()
        }
        
        return Singleton.sharedInstance
    }




}
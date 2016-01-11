//
//  Students.swift
//  OnTheMap
//
//  Created by zhangyunchen on 16/1/11.
//  Copyright © 2016年 zhangyunchen. All rights reserved.
//

import Foundation
class Students  {
    var students = [Student]()
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> Students {
        
        struct Singleton {
            static var sharedInstance = Students()
        }
        
        return Singleton.sharedInstance
    }
}
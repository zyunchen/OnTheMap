//
//  File.swift
//  OnTheMap
//
//  Created by zhangyunchen on 15/12/6.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

struct Student {
    var createdAt = ""
    var firstName = ""
    var lastName = ""
    var latitude = 0.0
    var longitude = 0.0
    var mapString = ""
    var mediaURL = ""
    var objectId = ""
    var uniqueKey = ""
    var updatedAt = ""
    init(dictionary: [String : AnyObject]) {
        createdAt = dictionary["createdAt"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        objectId = dictionary["objectId"] as! String
        uniqueKey = dictionary["uniqueKey"] as! String
        updatedAt = dictionary["updatedAt"] as! String
    }
}
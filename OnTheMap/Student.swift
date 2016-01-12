//
//  File.swift
//  OnTheMap
//
//  Created by zhangyunchen on 15/12/6.
//  Copyright © 2015年 zhangyunchen. All rights reserved.
//

struct Student {
    var createdAt:String?
    var firstName:String?
    var lastName :String?
    var latitude :Double?
    var longitude :Double?
    var mapString :String?
    var mediaURL :String?
    var objectId :String?
    var uniqueKey :String?
    var updatedAt :String?
    init(dictionary: [String : AnyObject]) {
        createdAt = dictionary["createdAt"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        objectId = dictionary["objectId"] as? String
        uniqueKey = dictionary["uniqueKey"] as? String
        updatedAt = dictionary["updatedAt"] as? String
    }
}
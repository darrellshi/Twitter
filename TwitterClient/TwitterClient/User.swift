//
//  File.swift
//  TwitterClient
//
//  Created by Darrell Shi on 2/9/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import Foundation

class User {
    var name: String?
    var screenName: String?
    var description: String?
    var followers: Int?
    var following: Int?
    var profileURL: String?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        description = dictionary["description"] as? String
        followers = dictionary["followers_count"] as? Int
        following = dictionary["following"] as? Int
        profileURL = dictionary["profile_image_url_https"] as? String
    }
}
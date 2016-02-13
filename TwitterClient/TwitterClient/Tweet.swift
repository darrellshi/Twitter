//
//  Tweet.swift
//  TwitterClient
//
//  Created by Darrell Shi on 2/9/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import Foundation

class Tweet {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
//    var retweeted: Bool?
//    var retweetCount: Int?
//    var favorited: Bool?
//    var favoritesCount: Int?
    
    init(dictionary: NSDictionary) {
        if let user = dictionary["user"] as? NSDictionary {
            self.user = User(dictionary: user)
        }
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
//        retweeted = dictionary["retweeted"] as? Bool
//        retweetCount = dictionary["retweet_count"] as? Int
//        favorited = dictionary["favorited"] as? Bool
//        favoritesCount = dictionary["favourites_count"] as? Int
//        print("retweeted = \(retweeted)")
//        print("retweetCount = \(retweetCount)")
//        print("favorited = \(favorited)")
//        print("favoritesCount = \(favoritesCount)")

    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
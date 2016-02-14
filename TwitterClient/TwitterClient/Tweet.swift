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
    var retweetCount: Int?
    var favoritesCount: Int?
    var id: Int?
    
    init(dictionary: NSDictionary) {
        if let user = dictionary["user"] as? NSDictionary {
            self.user = User(dictionary: user)
        }
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        retweetCount = dictionary["retweet_count"] as? Int
        favoritesCount = dictionary["favorite_count"] as? Int
        
        id = dictionary["id"] as? Int
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    private func sendPOSTRequest(URLString: String, completion: (response: AnyObject?, error: NSError?)->Void) {
        TwitterClient.sharedInstance.POST(URLString, parameters: nil, progress: { (progress: NSProgress) -> Void in
            }, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                completion(response: response, error: nil)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(response: nil, error: error)
        }
    }
    
    func retweet(completion: (response: AnyObject?, error: NSError?)->Void) {
        if let id = self.id {
            sendPOSTRequest("1.1/statuses/retweet/\(id).json?id=\(id)", completion: completion)
        } else {
            completion(response: nil, error: nil)
            print("Counldn't get tweet id")
        }
    }
    
    func unretweet(completion: (response: AnyObject?, error: NSError?)->Void) {
        if let id = self.id {
            sendPOSTRequest("1.1/statuses/unretweet/\(id).json?id=\(id)", completion: completion)
        } else {
            completion(response: nil, error: nil)
            print("Counldn't get tweet id")
        }
    }
    
    func favorite(completion: (response: AnyObject?, error: NSError?)->Void) {
        if let id = self.id {
            sendPOSTRequest("1.1/favorites/create.json?id=\(id)", completion: completion)
        } else {
            completion(response: nil, error: nil)
            print("Counldn't get tweet id")
        }
    }
    
    func unfavorite(completion: (response: AnyObject?, error: NSError?)->Void) {
        if let id = self.id {
            sendPOSTRequest("1.1/favorites/destroy.json?id=\(id)", completion: completion)
        } else {
            completion(response: nil, error: nil)
            print("Counldn't get tweet id")
        }
    }
}
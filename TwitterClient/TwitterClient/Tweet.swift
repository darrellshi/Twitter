//
//  Tweet.swift
//  TwitterClient
//
//  Created by Darrell Shi on 2/9/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import Foundation
import UIKit

class Tweet {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweetCount: Int?
    var favoritesCount: Int?
    var id: Int?
    var repliedToUserIdString: String?
    var retweeted: Bool?
    var favorited: Bool?
    
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
        
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        if let replyTo = dictionary["in_reply_to_user_id_str"] as? String {
            if replyTo == "" {
                repliedToUserIdString = nil
            } else {
                repliedToUserIdString = replyTo
            }
        } else {
            repliedToUserIdString = nil
        }
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
    
    func onReply(button: UIButton) {
        
    }
    
    func onRetweet(button: UIButton, label: UILabel) {
        if let status = retweeted {
            if status {
                unretweet(button, label: label)
            } else {
                retweet(button, label: label)
            }
        } else {
            retweet(button, label: label)
        }
    }
    
    private func retweet(button: UIButton, label: UILabel) {
        if let id = self.id {
            sendPOSTRequest("1.1/statuses/retweet/\(id).json?id=\(id)", completion: { (response, error) -> Void in
                if response != nil {
                    print("retweeted")
                    self.setRetweetStatus(button, label: label)
                } else {
                    print("Failed to retweet")
                    return
                }
            })
        } else {
            print("Counldn't get tweet id")
        }
    }
    
    private func unretweet(button: UIButton, label: UILabel) {
        if let id = self.id {
            sendPOSTRequest("1.1/statuses/unretweet/\(id).json?id=\(id)", completion: { (response, error) -> Void in
                if response != nil {
                    print("unretweeted")
                    self.setUnretweetStatus(button, label: label)
                } else {
                    print("Failed to unretweet")
                    return
                }
            })
        } else {
            print("Counldn't get tweet id")
        }
    }
    
    private func setRetweetStatus(button: UIButton, label: UILabel) {
        retweeted = true
        let retweetImage = UIImage(named: "retweet-action-on.png")
        button.setImage(retweetImage, forState: .Normal)
        self.retweetCount?++
        label.text = String(self.retweetCount!)
    }
    
    private func setUnretweetStatus(button: UIButton, label: UILabel) {
        retweeted = false
        let retweetImage = UIImage(named: "retweet-action.png")
        button.setImage(retweetImage, forState: .Normal)
        self.retweetCount?--
        if retweetCount != 0 {
            label.text = String(self.retweetCount!)
        } else {
            label.text = ""
        }
    }
    
    func onFavorite(button: UIButton, label: UILabel) {
        if let status = favorited {
            if status {
                unfavorite(button, label: label)
            } else {
                favorite(button, label: label)
            }
        } else {
            favorite(button, label: label)
        }
    }
    
    private func favorite(button: UIButton, label: UILabel) {
        if let id = self.id {
            sendPOSTRequest("1.1/favorites/create.json?id=\(id)", completion: { (response, error) -> Void in
                if response != nil {
                    print("favorited")
                    self.setFavoriteStatus(button, label: label)
                } else {
                    print("Failed to favorite")
                    return
                }
            })
        } else {
            print("Counldn't get tweet id")
        }
    }
    
    private func unfavorite(button: UIButton, label: UILabel) {
        if let id = self.id {
            sendPOSTRequest("1.1/favorites/destroy.json?id=\(id)", completion: { (response, error) -> Void in
                if response != nil {
                    print("unfavorited")
                    self.setUnfavoriteStatus(button, label: label)
                } else {
                    print("Failed to unfavorite")
                    return
                }
            })
        } else {
            print("Counldn't get tweet id")
        }
    }
    
    private func setFavoriteStatus(button: UIButton, label: UILabel) {
        favorited = true
        let favoriteImage = UIImage(named: "like-action-on.png")
        button.setImage(favoriteImage, forState: .Normal)
        self.favoritesCount?++
        label.text = String(self.favoritesCount!)
    }
    
    private func setUnfavoriteStatus(button: UIButton, label: UILabel) {
        favorited = false
        let favoriteImage = UIImage(named: "like-action.png")
        button.setImage(favoriteImage, forState: .Normal)
        self.favoritesCount?--
        if favoritesCount != 0 {
            label.text = String(self.favoritesCount!)
        } else {
            label.text = ""
        }
    }
}
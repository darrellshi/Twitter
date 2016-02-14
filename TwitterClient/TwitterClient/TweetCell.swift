//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Darrell Shi on 2/10/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var index: Int?
    
    var tweet: Tweet? {
        didSet{
            userNameLabel.text = tweet?.user?.name
            if let screenName = tweet?.user?.screenName {
                screenNameLabel.text = "@\(screenName)"
            }
            if let createdTime = tweet?.createdAt {
                let formater = NSDateFormatter()
                formater.dateFormat = "HH:mm - dd MMM YYYY"
                timeLabel.text = formater.stringFromDate(createdTime)
            }
            
            tweetTextLabel.text = tweet?.text
            if let imageURL = tweet?.user?.profileURL {
                userProfileImageView.setImageWithURL(NSURL(string: imageURL)!)
            }
            
            
            if let retweetCount = tweet?.retweetCount {
                if retweetCount != 0 {
                    retweetCountLabel.text = String(retweetCount)
                }
            }
            
            if let favoritedCount = tweet?.favoritesCount {
                if favoritedCount != 0 {
                    favoriteCountLabel.text = String(favoritedCount)
                }
            }
        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if let status = retweetStatus[index!] { // check whether retweet or unretweet
            if status { // unretweet
                tweet?.unretweet({ (response, error) -> Void in
                    if response != nil {
                        print("unretweeted")
                        self.setUnretweetStatus()
                    } else {
                        print("Failed to retweet")
                        return
                    }
                })
            } else { // retweet
                tweet?.retweet({ (response, error) -> Void in
                    if response != nil {
                        print("retweeted")
                        self.setRetweetStatus()
                    } else {
                        print("Failed to retweet")
                        return
                    }
                })
            }
        } else { // retweet
            tweet?.retweet({ (response, error) -> Void in
                if response != nil {
                    print("retweeted")
                    self.setRetweetStatus()
                } else {
                    print("Failed to retweet")
                    return
                }
            })
            
        }
    }
    
    func setRetweetStatus() {
        retweetStatus[index!] = true
        let retweetImage = UIImage(named: "retweet_icon_highlighted.png")
        retweetButton.setImage(retweetImage, forState: .Normal)
        tweet?.retweetCount?++
        retweetCountLabel.text = String(tweet!.retweetCount!)
    }
    
    func setUnretweetStatus() {
        retweetStatus[index!] = false
        let retweetImage = UIImage(named: "retweet_icon.png")
        retweetButton.setImage(retweetImage, forState: .Normal)
        tweet?.retweetCount?--
        retweetCountLabel.text = String(tweet!.retweetCount!)
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if let status = favoriteStatus[index!] {
            if status { // unfavorite
                tweet?.unfavorite({ (response, error) -> Void in
                    if response != nil {
                        print("unfavorited")
                        self.setUnfavoriteStatus()
                    } else {
                        print("Failed to unfavorite")
                        return
                    }
                })
            } else { // favorite
                tweet?.favorite({ (response, error) -> Void in
                    if response != nil {
                        print("favorited")
                        self.setFavoriteStatus()
                    } else {
                        print("Failed to favorite")
                        return
                    }
                })
            }
        } else { // favorite
            tweet?.favorite({ (response, error) -> Void in
                if response != nil {
                    print("favorited")
                    self.setFavoriteStatus()
                } else {
                    print("Failed to favorite")
                    return
                }
            })
        }
    }
    
    func setFavoriteStatus() {
        favoriteStatus[index!] = true
        let favoriteImage = UIImage(named: "favorite_icon_highlighted.png")
        favoriteButton.setImage(favoriteImage, forState: .Normal)
        tweet?.favoritesCount?++
        favoriteCountLabel.text = String(tweet!.favoritesCount!)
    }
    
    func setUnfavoriteStatus() {
        favoriteStatus[index!] = false
        let favoriteImage = UIImage(named: "favorite_icon.png")
        favoriteButton.setImage(favoriteImage, forState: .Normal)
        tweet?.favoritesCount?--
        favoriteCountLabel.text = String(tweet!.favoritesCount!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

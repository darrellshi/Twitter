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
    @IBOutlet weak var replyButton: UIButton!
    
    var delegate: TableCellDelegate?
    
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
            
            let tapGesture = UITapGestureRecognizer(target: self, action: "onUserProfile")
            tapGesture.numberOfTapsRequired = 1
            userProfileImageView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
        tweet?.onReply(replyButton)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        tweet?.onRetweet(retweetButton, label: retweetCountLabel)
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        tweet?.onFavorite(favoriteButton, label: favoriteCountLabel)
    }
    
    func onUserProfile() {
        if let screenName = screenNameLabel.text {
            delegate?.buttonDidTap(screenName)
        }
    }
}

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
        }
    }
}

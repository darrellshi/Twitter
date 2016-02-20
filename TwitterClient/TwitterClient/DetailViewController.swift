//
//  DetailViewController.swift
//  TwitterClient
//
//  Created by Darrell Shi on 2/16/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
//    @IBOutlet weak var attachedImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var tweet: Tweet?
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        
        if let url_str = tweet?.user?.profileURL {
            if let nsurl = NSURL(string: url_str) {
                profileImageView.setImageWithURL(nsurl)
            }
        }
        usernameLabel.text = tweet?.user?.name
        if let screenName = tweet?.user?.name {
            screenNameLabel.text = "@\(screenName)"
        }
        textLabel.text = tweet?.text
        if let createdTime = tweet?.createdAt {
            let formater = NSDateFormatter()
            formater.dateFormat = "HH:mm - dd MMM YYYY"
            timeLabel.text = formater.stringFromDate(createdTime)
        }
        if let retweetCount = tweet?.retweetCount {
            retweetsLabel.text = "\(retweetCount)"
        }
        if let likesCount = tweet?.favoritesCount {
            likesLabel.text = "\(likesCount)"
        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
        tweet?.onReply(replyButton)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        tweet?.onRetweet(retweetButton, label: retweetsLabel)
    }
    
    @IBAction func onLike(sender: AnyObject) {
        tweet?.onFavorite(likeButton, label: likesLabel)
    }
}

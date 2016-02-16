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
    @IBOutlet weak var attachedImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var tweet: Tweet?
    
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
        timeLabel.text = tweet?.createdAtString
        if let retweetCount = tweet?.retweetCount {
            retweetsLabel.text = "\(retweetCount) Retweets"
        }
        if let likesCount = tweet?.favoritesCount {
            likesLabel.text = "\(likesCount) Likes"
        }
    }
}

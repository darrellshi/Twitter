//
//  HomeViewController.swift
//  TwitterClient
//
//  Created by Darrell Shi on 2/10/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit

protocol TableCellDelegate: class {
    func buttonDidTap(screenName: String)
}

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    var refresher: UIRefreshControl!
    var isLoadingMoreData = false
    var screenName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "navigation_logo.png"))
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "onFresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refresher, atIndex: 0)
        
        TwitterClient.sharedInstance.homeTimelineWithCompletion("?count=20", params: nil) { (tweets, error) -> () in
            if tweets != nil {
                self.tweets = tweets
                self.tableView.reloadData()
            } else {
                print("Failed to get home timeline")
                print(error)
            }
        }

    }
    
    func onFresh() {
        TwitterClient.sharedInstance.homeTimelineWithCompletion("", params: nil) { (tweets, error) -> () in
            if tweets != nil {
                self.tweets = tweets
                self.tableView.reloadData()
                self.refresher.endRefreshing()
            } else {
                print("Failed to get home timeline")
            }
        }
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        print("logged out!")
        User.currentUser?.logOut()
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToDetailView" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell) {
                let vc = segue.destinationViewController as! DetailViewController
                vc.tweet = tweets?[indexPath.row]
            }
        }
        if segue.identifier == "ToUserHeaderViewController" {
            let vc = segue.destinationViewController as! UserHeaderViewController
            vc.screenName = self.screenName
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        let tweet = tweets![indexPath.row]
        cell.tweet = tweet
        if let retweeted = tweet.favorited {
            if retweeted {
                let retweetImage = UIImage(named: "retweet-action-on.png")
                cell.retweetButton.setImage(retweetImage, forState: .Normal)
            }
        }
        if let favorited = tweet.favorited {
            if favorited {
                let favoritedImage = UIImage(named: "like-action-on.png")
                cell.favoriteButton.setImage(favoritedImage, forState: .Normal)
            }
        }

        cell.delegate = self
        return cell
    }
}

extension HomeViewController: UIScrollViewDelegate, UIGestureRecognizerDelegate, TableCellDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !isLoadingMoreData {
            let scrollViewContentHeight = scrollView.contentSize.height
            let threshold = scrollViewContentHeight - scrollView.bounds.height
            if scrollView.contentOffset.y > threshold {
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        if let id = tweets?.last?.id {
            TwitterClient.sharedInstance.homeTimelineWithCompletion("?since_id=\(id)&count=20", params: nil) { (tweets, error) -> () in
                if tweets != nil {
                    self.tweets?.appendContentsOf(tweets!)
                    self.tableView.reloadData()
                } else {
                    print("Failed to get home timeline")
                }
            }
        } else {
            TwitterClient.sharedInstance.homeTimelineWithCompletion("?count=2", params: nil) { (tweets, error) -> () in
                if tweets != nil {
                    self.tweets?.appendContentsOf(tweets!)
                    self.tableView.reloadData()
                } else {
                    print("Failed to get home timeline")
                }
            }
        }
    }
    
    func buttonDidTap(screenName: String) {
        self.screenName = screenName
        performSegueWithIdentifier("ToUserHeaderViewController", sender: nil)
    }
}

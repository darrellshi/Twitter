//
//  HomeViewController.swift
//  TwitterClient
//
//  Created by Darrell Shi on 2/10/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    var refresher: UIRefreshControl!
    
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
        
        TwitterClient.sharedInstance.homeTimelineWithCompletion(nil) { (tweets, error) -> () in
            if tweets != nil {
                self.tweets = tweets
                self.tableView.reloadData()
            } else {
                print("Failed to get home timeline")
            }
        }
    }
    
    func onFresh() {
        TwitterClient.sharedInstance.homeTimelineWithCompletion(nil) { (tweets, error) -> () in
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
        print("log out!")
        User.currentUser?.logOut()
        performSegueWithIdentifier("ToLogin", sender: nil)
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
        cell.tweet = tweets![indexPath.row]
        return cell
    }
}

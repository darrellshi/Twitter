//
//  UserHeaderViewController.swift
//  TwitterClient
//
//  Created by Darrell Shi on 2/16/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit

class UserHeaderViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    var screenName: String?
    
    @IBOutlet weak var followButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient.sharedInstance.userTimelineWithCompletion(screenName!, params: nil) { (response, error) -> () in
            if let dictionary = response {
                let user = dictionary["user"] as! NSDictionary
                if let profileURL = user["profile_image_url_https"] as? String {
                    self.profileImageView.setImageWithURL(NSURL(string: profileURL)!)
                }
                self.nameLabel.text = user["name"] as? String
                self.screenNameLabel.text = "@\(user["screen_name"] as! String)"
                self.introductionLabel.text = user["description"] as? String
                self.tweetsLabel.text = "\(user["statuses_count"] as! Int)"
                self.followingLabel.text = "\(user["friends_count"] as! Int)"
                self.followersLabel.text = "\(user["followers_count"] as! Int)"                
            }
        }
    }
    
    private func popupMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onFollow(sender: AnyObject) {
        if let text = followButton.titleLabel!.text {
            if text == "Follow" {
                followButton.setTitle("Unfollow", forState: .Normal)
                popupMessage("Followed \(screenName!)")
            } else {
                followButton.setTitle("Follow", forState: .Normal)
                popupMessage("Unfollowed \(screenName!)")
            }
        }
        
        
//        let params = ["screen_name": screenName!] as NSDictionary
//        TwitterClient.sharedInstance.followUserWithCompletion(params) { (response, error) -> () in
//            if response != nil {
//                print("followed")
//                self.popupMessage("Followed \(self.screenName!)")
//            } else {
//                print("failed to follow")
//                self.popupMessage("Failed to follow \(self.screenName!)")
//            }
//        }
    }
    
}

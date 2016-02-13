//
//  ViewController.swift
//  TwitterClient
//
//  Created by Darrell Shi on 2/9/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithComplition { (user, error) -> () in
            if user != nil {
                self.performSegueWithIdentifier("ToHomeView", sender: nil)
            } else {
                print(error)
            }
        }
    }

    @IBAction func onSignup(sender: AnyObject) {
        if let url = NSURL(string: "https://twitter.com/signup") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


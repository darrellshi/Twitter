//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Darrell Shi on 2/9/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

let twitterConsumerKey = "LEVOTNpOAMWZUUC4W9U3ZLIKl"
let twitterConsumerSecret = "NTgCfAxA7HjJzg0FnX5zjvHdkZRfLndctOgcfgdBlcEZJEI474"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
}
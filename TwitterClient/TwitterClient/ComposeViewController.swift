//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by Darrell Shi on 2/20/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController,  UITextViewDelegate{
    @IBOutlet weak var textBox: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        textBox.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onPost(sender: AnyObject) {
        let text = textBox.text
        if text.characters.count > 140 {
            self.popupMessage("The tweet text has to be less than 140 characters")
        } else {
            let params = ["status": text] as NSDictionary
            TwitterClient.sharedInstance.postTweetWithCompletion(params, completion: { (response, error) -> () in
                if response != nil {
                    print("tweet posted")
                    self.popupMessage("Tweet posted!")
                } else {
                    print("Failed to post tweet")
                    self.popupMessage("Failed to tweet")
                }
            })
        }
    }

    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.blackColor()
    }
    
    private func popupMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

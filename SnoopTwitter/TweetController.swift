//
//  TweetController.swift
//  SnoopTwitter
//
//  Created by Philihp Busby on 2016-06-04.
//  Copyright © 2016 Philihp Busby. All rights reserved.
//

import UIKit

class TweetController: UIViewController {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    
    var tweet: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tweet = tweet {
            tweetLabel.text = tweet
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

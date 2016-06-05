//
//  TweetsViewController.swift
//  SnoopTwitter
//
//  Created by Philihp Busby on 2016-06-01.
//  Copyright © 2016 Philihp Busby. All rights reserved.
//


//http://dennissuratna.com/slide-out-navigation-swift/

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TimelineDelegate, MentionsDelegate, ProfileDelegate, LogoutDelegate, ComposeDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var tweets: [Tweet]!
    var timelineType: TimelineType = .Home
    
    var tappedProfileScreenname: String?
    var tappedTweetText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TweetsViewController.onRefresh), forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        reloadData()
    }
    
    func onRefresh() {
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func reloadData() {
        Twitter.client.timeline(timelineType) { (tweets: [Tweet]) in
            self.tweets = tweets
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func menuSelectLogout() {
        Twitter.client.logout() { () -> () in
            //self.performSegueWithIdentifier("LoginSegue", sender: nil)
        }
    }
    
    func menuSelectTimeline() {
        timelineType = TimelineType.Home
        reloadData()
    }
    
    func menuSelectMentions() {
        timelineType = TimelineType.Mentions
        reloadData()
    }
    
    func menuSelectProfile() {
        tappedProfileScreenname = String(Twitter.user!.screenname)
        self.performSegueWithIdentifier("ProfileSegue", sender: nil)
    }
   
    func tweet(message: String) {
        Twitter.client.composeTweet(message) { (tweet: Tweet) in
            print("composed: \(tweet)")
            self.tweets.removeLast()
            self.tweets.insert(tweet, atIndex: 0)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func tapShowProfile(sender: UITapGestureRecognizer) {
        // there has to be a better way
        tappedProfileScreenname = (sender.view!.nextResponder()!.nextResponder()! as! TweetCell).screenNameLabel.text!
        self.performSegueWithIdentifier("ProfileSegue", sender: nil)
    }
    
    @IBAction func tapShowTweet(sender: UITapGestureRecognizer) {
        tappedTweetText = "undefined tweet"
        self.performSegueWithIdentifier("TweetSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "ProfileSegue":
            if let profileController = segue.destinationViewController as? ProfileController {
                profileController.screenname = tappedProfileScreenname ?? Twitter.user!.screenname as String
            }
        case "TweetSegue":
            if let tweetController = segue.destinationViewController as? TweetController {
                tweetController.tweet = tappedTweetText ?? "xxx"
            }
        case "ComposeSegue":
            if let composeNavController = segue.destinationViewController as? UINavigationController,
                composeViewController = composeNavController.topViewController as? ComposeViewController {
                // this will happen if and only if the destination controller is a nav controller that has a ComposeViewController inside of it.
                composeViewController.delegate = self
            }
        default:
            break
        }
    }

}

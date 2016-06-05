//
//  Twitter.swift
//  SnoopTwitter
//
//  Created by Philihp Busby on 2016-06-01.
//  Copyright © 2016 Philihp Busby. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

enum TimelineType {
    case Home
    case Mentions
}

class Twitter: BDBOAuth1SessionManager {
    
    static let USER_KEY = "USER_KEY"
    static let NOTIFY_LOGOUT = "TWITTER_NOTIFY_LOGOUT"
    
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    static let client = Twitter(
        baseURL: NSURL(string: "https://api.twitter.com")!,
        consumerKey: "FlpoLdgcOJBRGjHFGr7AWoJ1v",
        consumerSecret: "IjN7Ps6HX1bHHHPBrkaB6ubGfkmViYSpdvuTeWcOXK361UZzqF")
    
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    static let DEFAULT_FAILURE_HANDLER = { (error: NSError!) in
        print("ERROR: \(error.description)")
    }
    
    static let DEFAULT_SUCCESS_HANDLER = { () in
    }
    
    static var _currentUser: User?
    class var user: User? {
        get {
            if(_currentUser == nil) {
                let serializedUser = defaults.objectForKey(USER_KEY) as? NSData
                if let serializedUser = serializedUser {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(serializedUser, options: []) as! NSDictionary
                    _currentUser = User(dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if let user = user {
                let serializedUser = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
                defaults.setObject(serializedUser, forKey: USER_KEY)
            } else {
                defaults.setObject(nil, forKey: USER_KEY)
            }
            defaults.synchronize()
        }
    }
    
    static func isLoggedOut() -> Bool {
        return user == nil
    }
    
    func login(failure: (NSError) -> () = DEFAULT_FAILURE_HANDLER, success: () -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        requestSerializer.removeAccessToken()
        deauthorize()
        
        fetchRequestTokenWithPath(
            "/oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "snooptwitter://oauth"),
            scope: nil,
            success: { (token: BDBOAuth1Credential!) -> Void in
                let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token.token)")!
                UIApplication.sharedApplication().openURL(url)
            },
            failure: { (error: NSError!) -> Void in
                self.loginFailure?(error)
            }
        )
    }
    
    func logout(failure: (NSError) -> () = DEFAULT_FAILURE_HANDLER, success: () -> () = DEFAULT_SUCCESS_HANDLER) {
        requestSerializer.removeAccessToken()
        deauthorize()
        Twitter.user = nil
        
        NSNotificationCenter.defaultCenter().postNotificationName(Twitter.NOTIFY_LOGOUT, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath(
            "/oauth/access_token",
            method: "POST",
            requestToken:
            requestToken,
            success: { (accessToken: BDBOAuth1Credential!) in
                self.requestSerializer.saveAccessToken(accessToken)
                self.currentAccount() { (user: User) in
                    Twitter.user = user
                }
                self.loginSuccess?()
            },
            failure: Twitter.DEFAULT_FAILURE_HANDLER)
    }
    
    func timeline(type: TimelineType, failure: (NSError) -> () = DEFAULT_FAILURE_HANDLER, success: ([Tweet]) -> ()) {
        var endpoint: String = ""
        switch(type) {
        case .Home:
            endpoint = "1.1/statuses/home_timeline.json"
        case .Mentions:
            endpoint = "1.1/statuses/mentions_timeline.json"
        }
        GET(endpoint,
            parameters: nil,
            progress: nil,
            success: { (_: NSURLSessionDataTask, response: AnyObject?) in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries)
                success(tweets)
            }, failure: { (_: NSURLSessionDataTask?, error: NSError) in
                failure(error)
            }
        )
    }
    
    func currentAccount(failure: (NSError) -> () = DEFAULT_FAILURE_HANDLER, success: (User) -> ()) {
        GET("1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (_: NSURLSessionDataTask, response: AnyObject?) in
                let userDictionary = response as! NSDictionary
                let user = User(userDictionary)
                success(user)
            },
            failure: { (_: NSURLSessionDataTask?, error: NSError) in
                failure(error)
            }
        )
    }
    
    func composeTweet(status: String, failure: (NSError) -> () = DEFAULT_FAILURE_HANDLER, success: (Tweet) -> ()) {
        let params: NSDictionary = [
            "status": status
        ]
        POST("1.1/statuses/update.json",
            parameters: params,
            progress: nil,
            success: { (_: NSURLSessionDataTask, response: AnyObject?) in
                if let response = response as? NSDictionary {
                    let tweet = Tweet(response)
                    success(tweet)
                } else {
                    failure(NSError(domain: "Response was not an NSDictionary", code: 555, userInfo: nil))
                }
            },
            failure: { (_: NSURLSessionDataTask?, error: NSError) in
                failure(error)
            }
        )
    }
    
}

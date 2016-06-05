//
//  User.swift
//  SnoopTwitter
//
//  Created by Philihp Busby on 2016-05-31.
//  Copyright © 2016 Philihp Busby. All rights reserved.
//

import UIKit

class User: NSObject {

    var dictionary: NSDictionary
    
    var name: NSString
    var screenname: NSString
    var profileImageUrl: NSURL
    var profileBackgroundUrl: NSURL
    var tagline: NSString
    
    init(_ dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String ?? ""
        screenname = dictionary["screen_name"] as? String ?? ""
        if let profileImageUrlString = dictionary["profile_image_url_https"] as? String {
            profileImageUrl = NSURL(string: profileImageUrlString)!
        } else {
            profileImageUrl = NSURL()
        }
        if let profileBackgroundUrlString = dictionary["profile_background_url_https"] as? String {
            profileBackgroundUrl = NSURL(string: profileBackgroundUrlString)!
        } else {
            profileBackgroundUrl = NSURL()
        }
        tagline = dictionary["description"] as? String ?? ""
    }
    
}

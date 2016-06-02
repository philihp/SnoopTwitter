//
//  User.swift
//  SnoopTwitter
//
//  Created by Philihp Busby on 2016-05-31.
//  Copyright © 2016 Philihp Busby. All rights reserved.
//

import UIKit

class User: NSObject {

    var dictionary: NSDictionary?
    
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = NSURL(string: profileUrlString)
        }
        tagline = dictionary["description"] as? String
    }
    
}

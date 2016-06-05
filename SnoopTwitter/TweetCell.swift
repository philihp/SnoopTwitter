//
//  TweetCell.swift
//  SnoopTwitter
//
//  Created by Philihp Busby on 2016-06-01.
//  Copyright © 2016 Philihp Busby. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var tweet: Tweet! {
        didSet {
            tweetLabel.text = String(tweet.text)
            screenNameLabel.text = String(tweet.user.screenname)
            timestampLabel.text = String(tweet.timestamp)
            profileImage.setImageWithURL(self.tweet.user.profileImageUrl)
            profileImage.layer.cornerRadius = 3
            profileImage.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.layoutSubviews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

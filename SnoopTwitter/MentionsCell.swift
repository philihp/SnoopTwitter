//
//  MentionsCell.swift
//  SnoopTwitter
//
//  Created by Philihp Busby on 2016-06-04.
//  Copyright © 2016 Philihp Busby. All rights reserved.
//

import UIKit

protocol MentionsDelegate {
    func menuSelectMentions()
}

class MentionsCell: UITableViewCell {

    var delegate: MentionsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if let delegate = delegate where selected == true {
            delegate.menuSelectMentions()
        }
    }

}

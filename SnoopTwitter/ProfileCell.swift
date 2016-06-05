//
//  ProfileCell.swift
//  SnoopTwitter
//
//  Created by Philihp Busby on 2016-06-04.
//  Copyright © 2016 Philihp Busby. All rights reserved.
//

import UIKit

protocol ProfileDelegate {
    func menuSelectProfile()
}

class ProfileCell: UITableViewCell {

    var delegate: ProfileDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if let delegate = delegate where selected == true {
            delegate.menuSelectProfile()
        }
    }

}

//
//  MenuViewController.swift
//  SnoopTwitter
//
//  Created by Philihp Busby on 2016-06-04.
//  Copyright © 2016 Philihp Busby. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    @IBOutlet weak var timelineCell: TimelineCell!
    @IBOutlet weak var mentionsCell: MentionsCell!
    @IBOutlet weak var profileCell: ProfileCell!
    @IBOutlet weak var logoutCell: LogoutCell!
    
    var delegate: AnyObject? {
        didSet{
            if let delegate = delegate as? TimelineDelegate {
                timelineCell.delegate = delegate
            }
            if let delegate = delegate as? MentionsDelegate {
                mentionsCell.delegate = delegate
            }
            if let delegate = delegate as? ProfileDelegate {
                profileCell.delegate = delegate
            }
            if let delegate = delegate as? LogoutDelegate {
                logoutCell.delegate = delegate
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

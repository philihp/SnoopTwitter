//
//  LoginViewController.swift
//  SnoopTwitter
//
//  Created by Philihp Busby on 2016-05-31.
//  Copyright © 2016 Philihp Busby. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onLoginButtonClicked(sender: UIButton) {
        Twitter.client.login() { () -> () in
            self.performSegueWithIdentifier("LoginSegue", sender: nil)
        }
    }
}

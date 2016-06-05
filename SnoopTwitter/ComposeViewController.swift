//
//  ComposeViewController.swift
//  SnoopTwitter
//
//  Created by Philihp Busby on 2016-06-04.
//  Copyright © 2016 Philihp Busby. All rights reserved.
//

import UIKit

protocol ComposeDelegate {
    func tweet(message: String)
}

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var tweetTextField: UITextField!
    var delegate: ComposeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tweetButtTapped(sender: UIBarButtonItem) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        if let delegate = delegate, text = tweetTextField.text {
            print("Tweeting: \(text)")
            delegate.tweet(text)
        }
    }
    
    @IBAction func cancelButtTapped(sender: UIBarButtonItem) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

}

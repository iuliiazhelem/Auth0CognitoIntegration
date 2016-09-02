//
//  ViewController.swift
//  AKSwiftAuth0Test
//

import UIKit

class ViewController: UIViewController {
    
    let loginManager = MyApplication.sharedInstance.loginManager

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var enterTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUsername()
    }
    
    @IBAction func clickSaveTextButton(sender: AnyObject) {
        self.setText()
    }
    
    @IBAction func clickLogoutButton(sender: AnyObject) {
        MyApplication.sharedInstance.clearData()
        A0Lock.sharedLock().clearSessions()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupUsername() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let upserProfile = MyApplication.sharedInstance.retrieveProfile()
            self.userNameLabel.text = upserProfile?.userId
            self.userEmailLabel.text = upserProfile?.name
            self.tokenLabel.text = MyApplication.sharedInstance.retrieveCognitoToken()
        })
        self.getText()
    }
    
    func clearUsername() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.userNameLabel.text = ""
            self.userEmailLabel.text = ""
            self.tokenLabel.text = ""
            self.textLabel.text = ""
        })
    }
    
    func getText() {
        MyApplication.sharedInstance.retrieveText { (text) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.textLabel.text = text
            })
        }
    }
    
    func setText() {
        MyApplication.sharedInstance.storeText(self.enterTextField.text)
        self.textLabel.text = self.enterTextField.text
    }
}


//
//  ViewController.swift
//  AKSwiftAuth0Test
//
//  Created by Iuliia Zhelem on 01.08.16.
//  Copyright © 2016 Akvelon. All rights reserved.
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
        let success = {() -> () in
            self.setupUsername()
        }
        let failure = {(error:NSError!) -> () in
            return
        }
        
        self.loginManager.resumeLogin(success, failure)
    }

    @IBAction func clickSaveTextButton(sender: AnyObject) {
        self.setText()
    }
    
    func socialAuthenticateWithName(name:String) {
        let success = { (profile: A0UserProfile, token: A0Token) in
            let success = {() -> () in
                self.setupUsername()
            }
            let failure = {(error: NSError!) -> () in
                NSLog("Error logging the user in %s", error!.description);
                self.showMessage("Error logging the user in \(error!.description)")
            }
            
            self.loginManager.completeLogin(token, profile, success, failure)
        }
        
        let failure = { (error: NSError) in
            print("Oops something went wrong: \(error)")
            MyApplication.sharedInstance.clearData()
            self.clearUsername()
        }
        A0Lock.sharedLock().identityProviderAuthenticator().authenticateWithConnectionName(name, parameters: nil, success: success, failure: failure)
        
    }
    
    @IBAction func clickGoogleButton(sender: AnyObject) {
        self.socialAuthenticateWithName(kGoogleConnectionName)
    }
    
    @IBAction func clickTwitterButton(sender: AnyObject) {
        self.socialAuthenticateWithName(kTwitterConnectionName)
    }
    
    @IBAction func clickFacebookButton(sender: AnyObject) {
        self.socialAuthenticateWithName(kFacebookConnectionName)
    }
    
    @IBAction func clickOpenLockUIButton(sender: AnyObject) {
        let controller = A0Lock.sharedLock().newLockViewController()
        controller.closable = true
        controller.onAuthenticationBlock = { (profile, token) in
            let success = {() -> () in
                self.setupUsername()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            let failure = {(error: NSError!) -> () in
                NSLog("Error logging the user in %s", error!.description);
                self.showMessage("Error logging the user in \(error!.description)")
            }
            
            self.loginManager.completeLogin(token!, profile!, success, failure)
           
        }
        
        self.presentViewController(controller, animated: true, completion: nil)
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
    
    func showMessage(message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "Auth0", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

}


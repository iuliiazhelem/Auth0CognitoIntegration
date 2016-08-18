//
//  LoginViewController.swift
//  AKSwiftAuth0Test
//
//  Created by Iuliia Zhelem on 10.08.16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation

class LoginViewController:UIViewController {
    
    let loginManager = MyApplication.sharedInstance.loginManager
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let success = {() -> () in
            self.openCognitoUserProfile()
        }
        let failure = {(error:NSError!) -> () in
            return
        }
        
        //Resume Amazon login if possible
        self.loginManager.resumeLogin(success, failure)
    }
    
    func socialAuthenticateWithName(name:String) {
        let success = { (profile: A0UserProfile, token: A0Token) in
            let success = {() -> () in
                MyApplication.sharedInstance.storeToken(token, profile: profile)
                self.openCognitoUserProfile()
            }
            let failure = {(error: NSError!) -> () in
                NSLog("Error logging the user in %s", error!.description);
                Auth0Alert().showMessage("Error logging the user in \(error!.description)", sender: self)
            }
            
            self.loginManager.completeLogin(token, profile, success, failure)
        }
        
        let failure = { (error: NSError) in
            print("Oops something went wrong: \(error)")
            MyApplication.sharedInstance.clearData()
            Auth0Alert().showMessage("Error logging the user in \(error.description)", sender: self)
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
    
    func openCognitoUserProfile() {
        performSegueWithIdentifier("CognitoUserProfile", sender: self)
    }
}

//
//  MyApplication.swift
//  SwiftSample
//
//  Created by Iuliia Zhelem on 01.08.16.
//  Copyright © 2016 Akvelon. All rights reserved.
//

import UIKit

let kCognitoTokenKeychainName = "cognito_token"
let kIdTokenKeychainName = "id_token"
let kRefreshTokenKeychainName = "refresh_token"
let kProfileKeychainName = "profile"
let kKeychainName = "Auth0"

class MyApplication: NSObject {
    class var sharedInstance :MyApplication {
        struct Singleton {
            static let instance = MyApplication()
        }
        return Singleton.instance
    }

    let keychain: A0SimpleKeychain
    
    let loginManager : LoginManager
    let dataset : AWSCognitoDataset

    private override init() {
        keychain = A0SimpleKeychain(service: "Auth0")
        loginManager = LoginManager()
        let cognitoSync = AWSCognito.defaultCognito()
        dataset = cognitoSync.openOrCreateDataset("MainDataset")
    }
    
    //Store/retrive JWT Tokens and user profile in/from Auth0 keychain
    func storeToken(token:A0Token?, profile:A0UserProfile?)
    {
        let keychain = A0SimpleKeychain(service: kKeychainName)
        self.storeIdToken(token?.idToken)
        self.storeProfile(profile)
        
        if let tkn = token, let refreshToken = tkn.refreshToken {
            keychain.setString(refreshToken, forKey: kRefreshTokenKeychainName)
        }
    }
    
    func storeIdToken(idToken:String?)
    {
        if let token = idToken {
            let keychain = A0SimpleKeychain(service: kKeychainName)
            keychain.setString(token, forKey: kIdTokenKeychainName)
            
        }
    }

    func storeCognitoToken(cognitoToken:String?)
    {
        if let token = cognitoToken {
            let keychain = A0SimpleKeychain(service: kKeychainName)
            keychain.setString(token, forKey: kCognitoTokenKeychainName)
            
        }
    }

    func storeProfile(profile:A0UserProfile?)
    {
        if let prof = profile {
            let keychain = A0SimpleKeychain(service: kKeychainName)
            keychain.setData(NSKeyedArchiver.archivedDataWithRootObject(prof), forKey: kProfileKeychainName)
        }
    }
    
    func retrieveIdToken() -> String?
    {
        let keychain = A0SimpleKeychain(service: kKeychainName)
        let token = keychain.stringForKey(kIdTokenKeychainName)
        return token
    }
    
    func retrieveCognitoToken() -> String?
    {
        let keychain = A0SimpleKeychain(service: kKeychainName)
        let token = keychain.stringForKey(kCognitoTokenKeychainName)
        return token
    }
    
    func retrieveRefreshToken() -> String?
    {
        let keychain = A0SimpleKeychain(service: kKeychainName)
        let token = keychain.stringForKey(kRefreshTokenKeychainName)
        return token
    }
    
    func retrieveProfile() -> A0UserProfile?
    {
        let keychain = A0SimpleKeychain(service: kKeychainName)
        if let data = keychain.dataForKey(kProfileKeychainName) {
            let profile = NSKeyedUnarchiver.unarchiveObjectWithData(data)
            return profile as? A0UserProfile
        }
        return nil
    }
    
    func clearData()
    {
        let keychain = A0SimpleKeychain(service: kKeychainName)
        keychain.clearAll()
    }
 
    //Read text from Amazon Cognito database
    func retrieveText(success : (String?) -> ()) 
    {
        
        self.dataset.synchronize().continueWithBlock {[weak self] (task) -> AnyObject! in
            success(self?.dataset.stringForKey("value"))
            return nil
        }
    }
    
    //Save text in Amazon Cognito database
    func storeText(text:String?)
    {
        if let actualText = text {
            self.dataset.setString(actualText, forKey: "value")
            self.dataset.synchronize().continueWithBlock { (task) -> AnyObject! in
                return nil
            }
           
        }
    }
}

class Auth0Alert {
    
    func showMessage(message: String, sender: UIViewController) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "Auth0", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            sender.presentViewController(alert, animated: true, completion: nil)
        }
        print("\(message)")
    }
}


# Auth0CognitoIntegration

This sample exposes how to integrate Amazon Cognito with Auth0.

You can integrate your mobile app with two solutions: 
- Auth0 to get authentication with either Social Providers (Facebook, Twitter, etc.), Enterprise providers or regular Username and Password
- Amazon Cognito, to get a backend for your app.

First of all you need to configure Amazon Web Services as describe [here](https://auth0.com/blog/integrating-auth0-with-amazon-cognito-in-ios/)

### Note: 
In order for Cognito to verify signature of your `Id Token`, the signature algorithm **must be RS256**. Setting this to RS256 in the Auth0 console ("Apps->Settings->Show Advanced Settings->OAuth") will allow Cognito to fetch the public key and certificate from your issuer's jwks uri.

Then you can integrate Amazon Cognito into your application. 

For this you need to add the following to your `Podfile`:
```
pod 'AWSCognito'
```

## Important Snippets

Note: All these snippets are located in the `LoginManager.swift` file.

### Step 1: Implement Cognito custom identity provider manager 
```swift
class CustomIdentityProviderManager: NSObject, AWSIdentityProviderManager{
    var tokens : [NSObject : AnyObject]?
    
    init(tokens: [NSObject : AnyObject]) {
        self.tokens = tokens
    }
    
    @objc func logins() -> AWSTask {
        return AWSTask(result: tokens)
    }
}
```
### Step 2: Initialize Amazon Cognito service manager with poolId 
```swift
init() {
    let poolId = NSBundle.mainBundle().objectForInfoDictionaryKey(kCognitoPoolId) as! String
    AWSLogger.defaultLogger().logLevel = AWSLogLevel.Verbose
    self.credentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.USWest2, identityPoolId:poolId)
    let configuration = AWSServiceConfiguration(region:AWSRegionType.USWest2, credentialsProvider:self.credentialsProvider)
    AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
}
```
### Step 3: Make Amazon login with idToken which you get after Auth0 authentication 
```swift
func doAmazonLogin(idToken: String, success : () -> (), _ failure : (NSError) -> ()) {
    var task: AWSTask?
    
    if self.credentialsProvider?.identityProvider.identityProviderManager == nil || idToken != MyApplication.sharedInstance.retrieveIdToken() {
        let IDPUrl = NSBundle.mainBundle().objectForInfoDictionaryKey(kCognitoIDPUrl) as! String
        let logins = [IDPUrl: idToken]
        task = self.initializeClients(logins)
    } else {
        self.credentialsProvider?.invalidateCachedTemporaryCredentials()
        task = self.credentialsProvider?.getIdentityId()
    }
    task!.continueWithBlock { (task: AWSTask!) -> AnyObject! in
        if (task.error != nil) {
            failure(task.error!)
        } else {
            // the task result will contain the identity id
            let cognitoId:String? = task.result as? String
            MyApplication.sharedInstance.storeCognitoToken(cognitoId)
            success()
        }
        return nil
    }
}

func initializeClients(logins: [NSObject : AnyObject]?) -> AWSTask? {
    print("Initializing Clients with logins")
    
    let manager = CustomIdentityProviderManager(tokens: logins!)
    self.credentialsProvider?.setIdentityProviderManagerOnce(manager)

    return self.credentialsProvider?.getIdentityId()
}
```

Before using the example please make sure that you change some keys in `Info.plist` with your data:

##### Auth0 data from [Auth0 Dashboard](https://manage.auth0.com/#/applications)
- Auth0ClientId
- Auth0Domain
- CFBundleURLSchemes

```
<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>auth0</string>
<key>CFBundleURLSchemes</key>
<array>
<string>a0{CLIENT_ID}</string>
</array>
```

##### Cognito data from [Amazon console](https://console.aws.amazon.com/iam/home?#providers)
- CognitoIDPUrl
- CognitoPoolID 

##### Twitter data from the configured [Social connection](https://manage.auth0.com/#/connections/social). For more details about connection your app to Twitter see [link](https://auth0.com/docs/connections/social/twitter)
- TwitterConsumerKey
- TwitterConsumerSecret

##### Facebook data from the configured [Social connection](https://manage.auth0.com/#/connections/social). For more details about connection your app to Facebook see [link](https://auth0.com/docs/connections/social/facebook)
- FacebookAppID
- CFBundleURLSchemes

```
<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>facebook</string>
<key>CFBundleURLSchemes</key>
<array>
<string>fb{FACEBOOK_APP_ID}</string>
</array>
```

##### For configuring Google authentication you need to download your own `GoogleServices-Info.plist` file from [this wizard](https://developers.google.com/mobile/add?platform=ios) and replace it with existing file. Also please find REVERSED_CLIENT_ID in this file and add it to CFBundleURLSchemes. For more details about connecting your app to Google see [this link](https://auth0.com/docs/connections/social/google) and [this iOS doc](https://auth0.com/docs/libraries/lock-ios/native-social-authentication#google):

- CFBundleURLSchemes

```
<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>Google</string>
<key>CFBundleURLSchemes</key>
<array>
<string>{REVERSED_CLIENT_ID}</string>
</array>
```

For more information about integrating of Auth0 with Amazon Cognito please check the following links:

* [Link1](https://auth0.com/blog/integrating-auth0-with-amazon-cognito-in-ios/)
* [Link2](http://docs.aws.amazon.com/mobile/sdkforios/developerguide/)
* [Link3](https://forums.aws.amazon.com/thread.jspa?messageID=696941)
* [Link4](http://docs.aws.amazon.com/cognito/latest/developerguide/open-id.html)







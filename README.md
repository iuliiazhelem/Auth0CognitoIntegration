# Auth0CognitoIntegration

This sample exposes how to integrate Amazon Cognito with Auth0.

You can integrate your mobile app with two solutions: Auth0 to get authentication with either Social Providers (Facebook, Twitter, etc.), Enterprise providers or regular Username and Password, and Amazon Cognito, to get a backend for your app.

First of all you need to configure Amazon Web Services as describe in https://auth0.com/blog/integrating-auth0-with-amazon-cognito-in-ios/

Note: In order for Cognito to verify signature of your Id Token, the signature algorithm must be RS256. Setting this to RS256 in auth0 console ("Apps->Settings->Show Advanced Settings->OAuth") will allow Cognito to fetch public key and certificate from your issuer's jwks uri

Then you can integrate Amazon Cognito into your applocation. 
For this you need to add 
```
  pod 'AWSCognito'
```
to your pod-file


#### Important Snippets

Note: All these snippets are located in the `LoginManager.swift` file.

##### 1. Implement Cognito custom identity provider manager 
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
##### 2. Initialize Amazon Cognito service manager with poolId 
```swift
    init() {
        let poolId = NSBundle.mainBundle().objectForInfoDictionaryKey(kCognitoPoolId) as! String
        AWSLogger.defaultLogger().logLevel = AWSLogLevel.Verbose
        self.credentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.USWest2, identityPoolId:poolId)
        let configuration = AWSServiceConfiguration(region:AWSRegionType.USWest2, credentialsProvider:self.credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
    }
```
##### 3. Make Amazon login with idToken which you get after Auth0 authentication 
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

Before using the example please make sure that you change some keys in Info.plist with your data:
- Auth0ClientId
- Auth0Domain
- CognitoIDPUrl
- CognitoPoolID
- TwitterConsumerKey
- TwitterConsumerSecret
- FacebookAppID
- GOOGLE_APP_ID
- REVERSED_CLIENT_ID
- CFBundleURLSchemes

```
<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>auth0</string>
<key>CFBundleURLSchemes</key>
<array>
<string>a01T8XeajR2FhDBAAz7JQ22mmzqCMoqzud</string>
</array>

a01T8XeajR2FhDBAAz7JQ22mmzqCMoqzud -> a0<Auth0ClientId>
```
```
<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>facebook</string>
<key>CFBundleURLSchemes</key>
<array>
<string>fb1038202126265858</string>
</array>

fb1038202126265858 -> fb<FacebookAppID>
```
```
<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>Google</string>
<key>CFBundleURLSchemes</key>
<array>
<string>com.googleusercontent.apps.514652084725-lbq4ulvpadvb4mmumqg7q3b46mvnshcd</string>
</array>

com.googleusercontent.apps.514652084725-lbq4ulvpadvb4mmumqg7q3b46mvnshcd -> REVERSED_CLIENT_ID
```

For more iformation about integrating of auth0 with Amazon cognito please see link

https://auth0.com/blog/integrating-auth0-with-amazon-cognito-in-ios/

http://docs.aws.amazon.com/mobile/sdkforios/developerguide/

https://forums.aws.amazon.com/thread.jspa?messageID=696941

http://docs.aws.amazon.com/cognito/latest/developerguide/open-id.html


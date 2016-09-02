//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Lock/Lock.h>
#import <Lock-Facebook/A0FacebookAuthenticator.h>
#import <SimpleKeychain/A0SimpleKeychain.h>
#import <Lock-Twitter/A0TwitterAuthenticator.h>
#import <Lock-Google/A0GoogleAuthenticator.h>

static NSString *kTwitterConnectionName = @"twitter";
static NSString *kGoogleConnectionName = @"google-oauth2";
static NSString *kFacebookConnectionName = @"facebook";

static NSString *kTwitterConsumerKey = @"TwitterConsumerKey";
static NSString *kTwitterConsumerSecret = @"TwitterConsumerSecret";
static NSString *kGoogleClientId = @"CLIENT_ID";
static NSString *kCognitoIDPUrl = @"CognitoIDPUrl";
static NSString *kCognitoPoolId = @"CognitoPoolID";

//Cognoto
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>

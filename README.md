# Auth0CognitoIntegration

Please make sure that you change some keys in `Info.plist`file with your data:
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

<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>auth0</string>
<key>CFBundleURLSchemes</key>
<array>
<string>a01T8XeajR2FhDBAAz7JQ22mmzqCMoqzud</string>
</array>

a01T8XeajR2FhDBAAz7JQ22mmzqCMoqzud -> a0<Auth0ClientId>

<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>facebook</string>
<key>CFBundleURLSchemes</key>
<array>
<string>fb1038202126265858</string>
</array>

fb1038202126265858 -> fb<FacebookAppID>

<key>CFBundleTypeRole</key>
<string>None</string>
<key>CFBundleURLName</key>
<string>Google</string>
<key>CFBundleURLSchemes</key>
<array>
<string>com.googleusercontent.apps.514652084725-lbq4ulvpadvb4mmumqg7q3b46mvnshcd</string>
</array>

com.googleusercontent.apps.514652084725-lbq4ulvpadvb4mmumqg7q3b46mvnshcd -> REVERSED_CLIENT_ID

For more information about integrating Auth0 with Amazon Cognito please check [here](https://auth0.com/blog/integrating-auth0-with-amazon-cognito-in-ios/).
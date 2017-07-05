# DreamhouseAnywhere
An iOS 10 and Swift 3 update to the <a href="https://github.com/quintonwall/dreamhouse-native">Dreamhouse Native app</a>, infused with AI, and a modern minimalist design. The primary intent of this app is to demonstrate multi-channel engagement using Salesforce as a mobile backend-as-a-service (mBaaS).

<img src="https://github.com/quintonwall/DreamhouseAnywhere/blob/master/graphics/screenshots/Menu.png?raw=true" width=270/>
<img src="https://github.com/quintonwall/DreamhouseAnywhere/blob/master/graphics/screenshots/Property%20Details.png?raw=true" width=270/>
<img src="https://github.com/quintonwall/DreamhouseAnywhere/blob/master/graphics/screenshots/Property%20List.png?raw=true" width=270/>



## Supported Features

### Rich Media Push Notifications
iOS 10 introduced the ability to add media attachments to push notifications. The Salesforce Platform already supports native push messaging from Apex. In order to take advantage of the new rich media features, follow the instructions [here](https://github.com/quintonwall/salesforce-tutorials/tree/master/universal-push-notification-framework) on how to use the helper class and Process Builder for sending notifications.

Once you have the backend set up, the DreamhouseAnywhere app already has a custom Message Extension included with it to handle the push notification, but if you want more information on how to create your own, check out this [tutorial](https://github.com/quintonwall/salesforce-tutorials/tree/master/ios10-richmedia-push-notifications).

### Apple Watch
<img src="https://github.com/quintonwall/DreamhouseAnywhere/blob/master/graphics/screenshots/AppleWatch.png?raw=true" width=270/>

### iMessages
<img src="https://github.com/quintonwall/DreamhouseAnywhere/blob/master/graphics/screenshots/iMessages.png?raw=true" width=270/>

### Real-time Video & Screen sharing
The app uses the Service Cloud SOS SnapIns to enable real-time video and screensharing. To use this feature, you need to perform the following config steps. Note: SOS SnapIns may require an additional license from Salesforce.

* Install [SOS quickstart package](https://salesforcesos.com) into your org.  
* Follow quickstart wizard steps in  Service Cloud using Setting up SOS in Service Cloud. Make you create a service cloud console via "Service Cloud Launch Pad" in setup.
* Configure live agent user.  You will need the following config variable to add to you mobile apps:
 - OrganizationID: 0000000xxxx
 - DeployementID :000000xxxx
 - SOS Access URL: https://x.xx.com/sosagentxxx/

* Configure you mobile app using the variables above and following [the instructions for iOS or Android](https://resources.docs.salesforce.com/servicesdk/1/0/en-us/pdf/service_sdk_ios.pdf)

### Social Sign On
Social sign on in the DreamhouseAnywhere mobile app relies on Salesforce communities login. The following sets are required to configure the backend Salesforce org. Unfortunately it is a little tricky, especially if it is the first time you have to do it.

#### 1. Create API Enabled Profile or Permission Set
(I prefer the profile as then I know I can use it in my social auth handler in step 2)
* Create a new profile based on "Community User"
* Check API Enabled
* Save

#### 2. Create a 'social integration' user
(this will be the user who creates new users and contacts on social sign-in)
* Create a user as normal. Give it a name like "Twitter SSO"
* Give it a Role (I like to create an integration-user role)
* Save

#### 3. Create a account to assign new users/contacts to
(I like to call it the name of my app, eg: "Dreamhouse App")
* create account.
* make owner you social integration user from above
* save

#### 4. Setup social login.
* follow the steps [here.](https://developer.salesforce.com/page/Login_with_Twitter)
* once you get to creating your own handler, paste in the sample handler from the docs above, but then change to use your new profiles and accounts created.


#### 5. Set up communities in your org

 * Make sure you check the ability to use your [Twitter Auth Provider](https://developer.salesforce.com/docs/atlas.en-us.noversion.mobile_sdk.meta/mobile_sdk/communities_tutorial.htm)
* create community name something like COMMUNITY-URL/dreamhousecustomers. eg: dreamhousenative-developer-edition.na30.force.com/dreamhousecustomers  (copy this url as you will need it soon)
* add the profile you created in step 1 to the allowed profiles of the community.
* customize your community login with a nice icon etc. (you have to check "show all settings" for the branding menu to show up)

At this point you have a community and social sign on set up. Now you have to create the mobile sdk side:

#### 6. Create a connected app
* add the following perms: Access and manage your data (api), Provide access to your data via the Web (web), Full access (full), Perform requests on your behalf at any time (refresh_token, offline_access). Call back can be anything like sfdc://success
* Save
* Copy and paste the oauth settings into you mobile app code.

#### 7. Set the oauth url for the mobile sdk to point to your community
* In your mobile apps Info.plist, add a new string key: SFDCOAuthLoginHost
* set its  value to the url of your community (without the https://). eg: dreamhousenative-developer-edition.na30.force.com/dreamhousecustomers
* save
* delete any existing app you have deployed on the simulator to remove keys stored by the mobile SDK.
* Click run and you should now be able to use social sign-in to auto create a community user right from a native app.

#### 8. Custom Object Permissions
* Update custom object permissions (setup -> Profiles --> the custom profile you created in step 1 above) to any objects you want to access from your mobile app
* Update field level security on those objects (setup --> security controls -> Field Accessibilty --> View by Profiles.)




### Anonymous APIs

### Serverless Functions with ApexRest

### Property Recommendations from PredictionIO

### Geo-location address fields
Properties use the Saleforce geo-location fields, and mapped to a strongly typed property struct in Swift. By mapping to a struct, it makes it super easy for the creation of beautiful geo-based apps. DreamhouseAnywhere uses MapBox to plot property locations on a map using a simple for loop
```swift
func plotPropertyLocations() {
        for p in properties {
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: p.latitude, longitude: p.longitude)
            point.title = p.title
            point.subtitle = p.description

            mapView.addAnnotation(point)
        }
    }

```
<img src="https://github.com/quintonwall/DreamhouseAnywhere/blob/master/graphics/screenshots/mapview.png?raw=true" width=270/>




# Building the App
## Cocoapods & Xcode 8
Xcode 8 seems to like checking the "App Extensions" checkbox in the general tab of your targets. This will cause issues with 'shared' variable instances. Simply uncheck "Allow app extension API only" in Targets that called from UIKit
You will have to do this each time you run Pod install :(

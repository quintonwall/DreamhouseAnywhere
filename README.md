# DreamhouseAnywhere
An iOS 10 and Swift 3 update to the <a href="https://github.com/quintonwall/dreamhouse-native">Dreamhouse Native app</a>, infused with AI, and a modern minimalist design. The primary intent of this app is to demonstrate multi-channel engagement using Salesforce as a mobile backend-as-a-service (mBaaS). 

<img src="https://github.com/quintonwall/DreamhouseAnywhere/blob/master/graphics/screenshots/Menu.png?raw=true" width=270/> 
<img src="https://github.com/quintonwall/DreamhouseAnywhere/blob/master/graphics/screenshots/Property%20Details.png?raw=true" width=270/> 
<img src="https://github.com/quintonwall/DreamhouseAnywhere/blob/master/graphics/screenshots/Property%20List.png?raw=true" width=270/> 
<img src="https://github.com/quintonwall/DreamhouseAnywhere/blob/master/graphics/screenshots/iMessages.png?raw=true" width=270/> 
<img src="https://github.com/quintonwall/DreamhouseAnywhere/blob/master/graphics/screenshots/AppleWatch.png?raw=true" width=270/> 

##Supported Features

### Rich Media Push Notifications

### Apple Watch

### iMessages

### Real-time Video & Screen sharing

### Social Sign On

### Anonymous APIs

### Serverless Functions with ApexRest

### Property Recommendations from PredictionIO

### Geo-location address fields



# Building the App
## Cocoapods & Xcode 8
Xcode 8 seems to like checking the "App Extensions" checkbox in the general tab of your targets. This will cause issues with 'shared' variable instances. Simply uncheck "Allow app extension API only" in Targets that called from UIKit
You will have to do this each time you run Pod install :(

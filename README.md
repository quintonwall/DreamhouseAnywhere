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
rc="https://github.com/quintonwall/DreamhouseAnywhere/blob/master/graphics/screenshots/mapview.png?raw=true" width=270/>




# Building the App
## Cocoapods & Xcode 8
Xcode 8 seems to like checking the "App Extensions" checkbox in the general tab of your targets. This will cause issues with 'shared' variable instances. Simply uncheck "Allow app extension API only" in Targets that called from UIKit
You will have to do this each time you run Pod install :(

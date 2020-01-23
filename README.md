# Cafe POS
I created this as a side project and also to help a friend manage sales at her small cafe in Wat Phnom, Phnom Penh. It was built with SwiftUI intended for iPad use. The app can manages orders, calculates change based on the dual KHR/USD currency used in Cambodia, as well as generating daily sales reports. It is also capable of connecting to a bluetooth printer to issue receipts. The app is currently distributed ad hoc as I am currently based in Sydney. Further improvements and features are currently being developed.

---
## Getting Started
### Prerequisites
* A device running **MacOS Catalina** or greater and
* An iPhone or iPad with **iOS13** or greater to be able to compile and run the code.
* KKmoon POS-5802DD portable thermal printer if you wish to test the printing functionality. (https://www.amazon.com.au/KKmoon-POS-5802DD-Portable-Wireless-Printing/dp/B01MY9H22U)

### Installing
Simply pull this repo, open it onto Xcode 11 or later and run on a compatible device or simulator. Note that the simulator will not have bluetooth functionality.

---
## About this app
This app was built mainly with SwiftUI. Features of Swift it utitlises:
### Codable 
It uses Swift's Codable protocol to create and encode orders to JSON files. Orders are stored in folders ordered by yyyy/mon/dd.
### @State, @EnvironmentObject, @Binding & @ObservedObject
These were used to display order properties as well as pass order items across multiple views and reusable component.
### CoreBluetooth
CoreBluetooth was used to establish a connection with the receipt printer and issue receipts.
### Apple's Biometric Authentication
This functionality is used to grant access to users attempting to view financial information regarding daily (and monthly) sales reports. As this app is meant to be used by both sales staff and shop owner, the feature was necessary.

---
## Acknowledgements
### [Hacking With Swift](https://www.hackingwithswift.com/)
Paul Hudson's guides have been incredibly helpful in helping me get accustomed to this new framework and language. A good start if you're looking to learn SwiftUI would be this tutorial: [iDine](https://www.hackingwithswift.com/quick-start/swiftui/swiftui-tutorial-building-a-complete-project)

### [Colorhunt](https://colorhunt.co/)
Color Hunt is really great if you cannot design for the life of you (like me). Aesthetically pleasing color schemes from more design-gifted people are posted there for your styling needs.

### [Stack Overflow](https://stackoverflow.com/)
Of course where would I be without this site. Notable threads that REALLY helped me print to a bluetooth printer from an iOS device:
* [Characteristic and Print Buffer](https://stackoverflow.com/questions/31353112/ios-corebluetooth-print-cbservice-and-cbcharacteristic) - Kudos to Giorgio for laying out which characteristics were meant for printing and pointing out the print buffer.
* [BLEConnection](https://stackoverflow.com/questions/58239721/render-list-after-bluetooth-scanning-starts-swiftui) - information from here provided me with a really good understanding of how bluetooth connections work in SwiftUI.

### [Raywenderlich.com](https://www.raywenderlich.com/231-core-bluetooth-tutorial-for-ios-heart-rate-monitor)
Although this guide is not specifically for SwiftUI, I was still able to learn how connecting to a BLE device should work and adapt it to the new framework by Apple.

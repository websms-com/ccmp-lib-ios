# websms CCMP Library (iOS)

SMS2App from websms combines the cost advantages of push messaging and the reliability of SMS texting into one single product. The offered SDK enables our customers to integrate SMS2App into their own application in order to benefit from both worlds – Push and SMS.
 
For more information about SMS2App, visit our [website](https://websms.de/produkte/sms2app)

## Requirements
* Xcode 4.5 or higher
* Apple LLVM compiler
* iOS 5.0 or higher
* ARC

## Demo

The demo application is available under [GitHub](https://github.com/websms-com/ccmp-example-ios)

## Installation

### CocoaPods

The recommended approach for installating `ccmp-lib-ios` is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.
For best results, it is recommended that you install via CocoaPods >= **0.15.2** using Git >= **1.8.0** installed via Homebrew.

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Change to the directory of your Xcode project:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
```

Edit your Podfile and add the library:

``` bash
platform :ios, '6.0'
pod 'ccmp-lib-ios', '~> 1.1.1'
```

Install into your Xcode project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

Please note that if your installation fails, it may be because you are installing with a version of Git lower than CocoaPods is expecting. Please ensure that you are running Git >= **1.8.0** by executing `git --version`. You can get a full picture of the installation details by executing `pod install --verbose`.

## Contributors

Christoph Lückler ([@oe8clr](https://github.com/oe8clr))

## Contact

sms.at mobile internet services gmbh<br>
Münzgrabenstraße 92/4<br>
A-8010 Graz

- https://github.com/websms-com
- https://twitter.com/websms_com
- sms2app@websms.com

## License

ccmp-lib-ios is available under the MIT license.

Copyright © 2014 sms.at mobile internet services gmbh

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

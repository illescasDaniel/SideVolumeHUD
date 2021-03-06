<p align="center">
   <img width="200" src="https://raw.githubusercontent.com/SvenTiigi/SwiftKit/gh-pages/readMeAssets/SwiftKitLogo.png" alt="SideVolumeHUD Logo">
</p>

<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat" alt="Swift 5.0">
   </a>
   <a href="http://cocoapods.org/pods/SideVolumeHUD">
      <img src="https://img.shields.io/cocoapods/v/SideVolumeHUD.svg?style=flat" alt="Version">
   </a>
   <a href="http://cocoapods.org/pods/SideVolumeHUD">
      <img src="https://img.shields.io/cocoapods/p/SideVolumeHUD.svg?style=flat" alt="Platform">
   </a>
   <a href="https://github.com/Carthage/Carthage">
      <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage Compatible">
   </a>
   <a href="https://twitter.com/Daniel_ir96/">
      <img src="https://img.shields.io/badge/Twitter-@Daniel_ir96-blue.svg?style=flat" alt="Twitter">
   </a>
</p>

# SideVolumeHUD

<p align="center">
Nice looking volume HUD that appears right to the physical volume buttons of your device.
You can also use it in landscape style, which looks really cool too :D
</p>

## Features

- Multiple animations available (slideInOut, enlarge, fadeInOut)
- All **options**:
  - Animations
    - enlarge
    - slideLeftRight -> default
    - fadeInOut
  - Theme
    - light
    - dark -> default
  - Orientation
    - vertical -> default
    - horizontal

## Example

The example application is the best way to see `SideVolumeHUD` in action. Simply open the `SideVolumeHUD.xcodeproj` and run the `Example` scheme.
Remember to run it on a real device, since custom volume views doesn't work in the simulator.

## Screenshots & videos

<p float="left">
   <img src="github/DemoVideo.gif" width="150">
  <img src="github/images/vertical_.png" width="250">
</p>

## Installation

### CocoaPods (volume icons not working - Its a [CocoaPods Issue](https://github.com/CocoaPods/CocoaPods/issues/8122))

SideVolumeHUD is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```bash
pod 'SideVolumeHUD'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate SideVolumeHUD into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "illescasDaniel/SideVolumeHUD"
```

Run `carthage update` to build the framework and drag the built `SideVolumeHUD.framework` into your Xcode project.

On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase” and add the Framework path as mentioned in [Carthage Getting started Step 4, 5 and 6](https://github.com/Carthage/Carthage/blob/master/README.md#if-youre-building-for-ios-tvos-or-watchos)

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate SideVolumeHUD into your project manually. Simply drag the `Sources` Folder into your Xcode project.

## Usage

In `AppDelegate.swift`, `application(_, didFinishLaunchingWithOptions)`:
```swift
SideVolumeHUD.hideDefaultVolumeHUD(from: self.window)
SideVolumeHUD.shared.setup(withOptions: [.animationStyle(.slideLeftRight)])
```

## Contributing
Contributions are very welcome 🙌

## License

```
SideVolumeHUD
Copyright (c) 2019 Daniel Illescas Romero illescas.daniel@protonmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

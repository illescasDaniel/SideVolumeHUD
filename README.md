SideVolumeHUD
----
[![Swift version](https://img.shields.io/badge/Swift-4-orange.svg)](https://swift.org/download)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/illescasDaniel/SideVolumeHUD/blob/master/LICENSE)

Nice looking volume HUD that appears right to the physical volume buttons of your device.
You can also use it in landscape style, which looks really cool too :D

(gifs might look a bit slower than the actual animations)
<p float="left">
  <img src="github/DemoVideo.gif" width="270">
  <img src="github/DemoVideoLandscape.gif" width="270">
</p>

## Features
- Multiple animations available (slideInOut, enlarge, fadeInOut)
- Haptic feedback
- Only one place and call to set it all up:
```swift
// in AppDelegate.swift, application(_, didFinishLaunchingWithOptions)
SideVolumeHUD.shared.setup(withStyle: .slideLeftRight)
```

## Screenshots
<p float="left">
  <img src="github/images/horizontal_.png" width="250">
  <img src="github/images/vertical_.png" width="250">
</p>

### Minor TODOs:
- *Check how it looks with other devices (In iPhone X looks nice)
- Test with other frameworks that uses windows or overlays
- Maybe change from vertical to horizontal orientation dynamically (like when the user invokes the keyboard)

### License
MIT license.

Icons from:
- https://icons8.com/icon/60709/volume-up
- https://icons8.com/icon/91634/volume-down
- https://icons8.com/icon/pack/astrology/ios-glyphs

If you have [thii/FontAwesome.swift](https://github.com/thii/FontAwesome.swift) in your project, it will try to use some font awesome icons instead :)

//
//  AppDelegate.swift
//  Example
//
//  Created by Daniel Illescas Romero on 15 May 2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import UIKit
import SideVolumeHUD

// MARK: - AppDelegate

/// The AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// The UIWindow
    var window: UIWindow?

    /// The RootViewController
    var rootViewController: UIViewController {
        return ViewController()
    }

    /// Application did finish launching with options
    ///
    /// - Parameters:
    ///   - application: The UIApplication
    ///   - launchOptions: The LaunchOptions
    /// - Returns: The launch result
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize UIWindow
        self.window = .init(frame: UIScreen.main.bounds)
        // Set RootViewController
        self.window?.rootViewController = self.rootViewController
        // Make Key and Visible
        self.window?.makeKeyAndVisible()
        // Return positive launch
		
		// Setup Side Volume HUD
		SideVolumeHUD.hideDefaultVolumeHUD(from: self.window)
		SideVolumeHUD.shared.setup(withOptions: [.animationStyle(.slideLeftRight)])
		
        return true
    }

}

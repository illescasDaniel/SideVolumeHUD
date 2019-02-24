//  SideVolumeHUDWindow.swift
//  by Daniel Illescas Romero
//  Github: @illescasDaniel
//  License: MIT

import UIKit
import class MediaPlayer.MPVolumeView

public class SideVolumeHUD {
	
	public static let shared = SideVolumeHUD()
	
	public enum AnimationStyle {
		case enlarge
		case slideLeftRight
		case fadeInOut
	}
	
	private let window = UIWindow()
	
	fileprivate init() {
		self.window.backgroundColor = UIColor.clear
		self.window.frame = UIScreen.main.bounds
		self.window.windowLevel = .normal
		self.window.alpha = 1
		self.window.isHidden = true
		self.hideDefaultVolumeHUD(from: UIApplication.shared.delegate?.window ?? nil)
		self.window.makeKey()
	}
	
	public func setup(withStyle animationStyle: SideVolumeHUD.AnimationStyle = .slideLeftRight, landscapeStyle: Bool = false) {
		
		let sideVolumeHUD = SideVolumeHUDHolderView(withStyle: animationStyle, hudWindow: self.window, portrait: !landscapeStyle)
		
		let viewController = UIViewController()
		viewController.view.frame = self.window.frame
		viewController.view.backgroundColor = .clear
		sideVolumeHUD.configure(for: viewController.view)
		
		self.window.rootViewController = viewController
	}
	
	private func hideDefaultVolumeHUD(from window: UIWindow?) {
		window?.addSubview(MPVolumeView())
	}
}

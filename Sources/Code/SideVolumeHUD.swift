//  SideVolumeHUD.swift
//  by Daniel Illescas Romero
//  Github: @illescasDaniel
//  License: MIT

@_exported import Foundation
/*import MediaPlayer
import UIKit*/
@_exported import class UIKit.UIViewController
@_exported import class UIKit.UITapGestureRecognizer
@_exported import class UIKit.UIScreen
@_exported import class UIKit.UIView
@_exported import class UIKit.UIWindow
@_exported import class UIKit.UIColor
@_exported import class UIKit.UIImage
@_exported import class UIKit.UISlider
@_exported import class UIKit.UIBlurEffect
@_exported import class UIKit.UIBezierPath
@_exported import class UIKit.UIMotionEffectGroup
@_exported import func UIKit.UIGraphicsBeginImageContextWithOptions
@_exported import func UIKit.UIGraphicsEndImageContext
@_exported import func UIKit.UIGraphicsGetCurrentContext
@_exported import class UIKit.UILayoutGuide
@_exported import class UIKit.UIInterpolatingMotionEffect
@_exported import struct UIKit.UIRectCorner
@_exported import class UIKit.UIVisualEffectView
@_exported import class UIKit.UIImpactFeedbackGenerator
@_exported import class UIKit.UISelectionFeedbackGenerator
@_exported import class UIKit.UIGraphicsImageRenderer
@_exported import struct CoreGraphics.CGFloat
@_exported import struct CoreGraphics.CGRect
@_exported import struct CoreGraphics.CGSize
@_exported import struct CoreGraphics.CGPoint
@_exported import struct CoreGraphics.CGAffineTransform
@_exported import class QuartzCore.CAShapeLayer
@_exported import class MediaPlayer.MPVolumeView

public class SideVolumeHUD {
	
	public static let shared = SideVolumeHUD()
	
	private let window = UIWindow()
	
	fileprivate init() {
		self.window.backgroundColor = UIColor.clear
		self.window.frame = UIScreen.main.bounds
		self.window.windowLevel = .normal
		self.window.alpha = 1
		self.window.isHidden = true
		self.window.makeKey()
	}
	
	/// Default options: dark, vertical, slideLeftRight animation, with 'special effects'
	public func setup(withOptions options: Set<Option> = []) {
		
		let sideVolumeHUD = SideVolumeHUDHolderView(withOptions: self.optionSetToOptions(options: options),
													hudWindow: self.window)
		
		let viewController = UIViewController()
		viewController.view.frame = self.window.frame
		viewController.view.backgroundColor = .clear
		sideVolumeHUD.configure(for: viewController.view)
		viewController.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
																		action: #selector(self.backgroundViewAction)))
		
		self.window.rootViewController = viewController
	}
	
	@objc private func backgroundViewAction(_ sender: UIView) {
		UIView.animate(withDuration: 0.15, animations: {
			self.window.alpha = 0
		}, completion: { completed in
			if completed {
				self.window.isHidden = true
				self.window.alpha = 1
			}
		})
	}
	
	static public func hideDefaultVolumeHUD(from window: UIWindow?) {
		window?.addSubview(MPVolumeView())
	}
	
	private func optionSetToOptions(options: Set<Option>) -> Options {
		var optionsTheme: Option.Theme = .dark
		var optionsOrientation: Option.Orientation = .vertical
		var optionsAnimationStyle: Option.AnimationStyle = .slideLeftRight
		var optionsUseSpecialEffects: Bool = true
		
		for option in options {
			switch option {
			case .theme(let theme):
				optionsTheme = theme
			case .orientation(let orientation):
				optionsOrientation = orientation
			case .animationStyle(let animationStyle):
				optionsAnimationStyle = animationStyle
			case .useSpecialEffects(let useSpecialEffets):
				optionsUseSpecialEffects = useSpecialEffets
			}
		}
		
		return Options(theme: optionsTheme, orientation: optionsOrientation,
					   animationStyle: optionsAnimationStyle, useSpecialEffects: optionsUseSpecialEffects)
	}
}

// MARK: - Details
extension SideVolumeHUD {
	public enum Option: Hashable {
		/// Only available if useSpecialEffects is true (which is its default value)
		case theme(Theme)
		case orientation(Orientation)
		case animationStyle(AnimationStyle)
		/// parallax effect, perfect round corners, etc
		case useSpecialEffects(Bool)
	}
	internal struct Options {
		public let theme: Option.Theme
		public let orientation: Option.Orientation
		public let animationStyle: Option.AnimationStyle
		public let useSpecialEffects: Bool
		public static let defaults = Options(theme: .dark, orientation: .vertical,
											 animationStyle: .slideLeftRight, useSpecialEffects: true)
	}
}

public extension SideVolumeHUD.Option {
	enum AnimationStyle: Hashable {
		case enlarge
		case slideLeftRight
		case fadeInOut
	}
	enum Theme: Hashable {
		case dark
		case light
	}
	enum Orientation: Hashable {
		case vertical
		case horizontal
	}
}

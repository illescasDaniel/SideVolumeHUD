//  SideVolumeHUDHolderView.swift
//  by Daniel Illescas Romero
//  Github: @illescasDaniel
//  License: MIT

import func Foundation.pow
import class Dispatch.DispatchQueue
import struct Dispatch.DispatchTime
import struct Foundation.NSNotification.Notification
import class Foundation.NSNotification.NotificationCenter
import class UIKit.UIWindow
import class UIKit.UIView
import class UIKit.UIColor
import class UIKit.UIBlurEffect
import class UIKit.UIBezierPath
import class UIKit.UIMotionEffectGroup
import func UIKit.UIGraphicsEndImageContext
import func UIKit.UIGraphicsGetCurrentContext
import class UIKit.UILayoutGuide
import class UIKit.UIInterpolatingMotionEffect
import struct UIKit.UIRectCorner
import class UIKit.UIVisualEffectView
import class UIKit.UIImpactFeedbackGenerator
import class UIKit.UISelectionFeedbackGenerator
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
import struct CoreGraphics.CGAffineTransform
import class QuartzCore.CAShapeLayer

#if canImport(Haptica)
import Haptica
#endif

fileprivate extension Notification.Name {
	enum AVSystemController: String {
		case audioVolumeNoficationKey = "AVSystemController_SystemVolumeDidChangeNotification"
		static let AudioVolumeNoficationParameter = Notification.Name(rawValue: audioVolumeNoficationKey.rawValue)
	}
}

class SideVolumeHUDHolderView: UIView {
	
	private static var (leading, top): (CGFloat, CGFloat) = (15, 95)
	private static var (height, width): (CGFloat, CGFloat) = (160, 50)
	private weak var volumeHUDWindow: UIWindow?
	private var options: SideVolumeHUD.Options = SideVolumeHUD.Options.defaults
	
	convenience init(withOptions options: SideVolumeHUD.Options, hudWindow: UIWindow?) {
		self.init()
		self.options = options
		self.volumeHUDWindow = hudWindow
		self.setupFrames()
		self.setupNotifications()
		self.setupVolumeView()
		self.setupView()
	}
	
	// MARK: - Convenince
	
	func configure(for view: UIView) {
		self.setupConstraints(for: view)
	}
	
	private func setupFrames() {
		if self.options.orientation == .horizontal {
			(SideVolumeHUDHolderView.leading, SideVolumeHUDHolderView.top,
			 SideVolumeHUDHolderView.height, SideVolumeHUDHolderView.width)
				= (SideVolumeHUDHolderView.top, SideVolumeHUDHolderView.leading,
				   SideVolumeHUDHolderView.width, SideVolumeHUDHolderView.height)
		}
		self.frame = CGRect(x: SideVolumeHUDHolderView.leading, y: SideVolumeHUDHolderView.top,
							width: SideVolumeHUDHolderView.width, height: SideVolumeHUDHolderView.height)
	}
	
	private func setupView() {
		if self.options.useSpecialEffects {
			if self.options.theme == .dark {
				self.backgroundColor = .clear
			} else if self.options.theme == .light {
				self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
			}
			
			self.addSpecialEffects()
		} else {
			self.layer.cornerRadius = 20
			self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
		}
		self.clipsToBounds = true
		if let transform = self.defaultTransformation(for: self.options.animationStyle).initialTransform {
			self.transform = transform
		}
	}
	
	private func setupNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.volumeDidChange),
											   name: Notification.Name.AVSystemController.AudioVolumeNoficationParameter, object: nil)
	}
	
	private func setupConstraints(for view: UIView) {
		let margins: UILayoutGuide
		/*if #available(iOS 11.0, *) {
		margins = view.safeAreaLayoutGuide
		} else {*/
		margins = view.layoutMarginsGuide
		//}
		view.addSubview(self)
		self.translatesAutoresizingMaskIntoConstraints = false
		if self.options.orientation == .vertical {
			self.leadingAnchor.constraint(equalTo: margins.leadingAnchor,
										  constant: SideVolumeHUDHolderView.leading).isActive = true
			self.topAnchor.constraint(equalTo: margins.topAnchor,
									  constant: SideVolumeHUDHolderView.top).isActive = true
		} else {
			self.leadingAnchor.constraint(equalTo: margins.centerXAnchor,
										  constant: -(SideVolumeHUDHolderView.width / 2)).isActive = true
			self.topAnchor.constraint(equalTo: margins.topAnchor,
									  constant: SideVolumeHUDHolderView.top).isActive = true
		}
		self.heightAnchor.constraint(equalToConstant: SideVolumeHUDHolderView.height).isActive = true
		self.widthAnchor.constraint(equalToConstant: SideVolumeHUDHolderView.width).isActive = true
		self.layer.zPosition = 1
	}
	
	private func setupVolumeView() {
		let volumeView = SideVolumeHUDView(frame: self.bounds, portrait: self.options.orientation == .vertical,
										   theme: self.options.theme)
		volumeView.tag = 10
		self.addSubview(volumeView)
	}
	
	private var animatingVolumeChange = false
	
	@objc private func volumeDidChange() {
		
		guard !self.animatingVolumeChange else {
			#if canImport(Haptica)
			Haptic.selection.generate()
			#else
			if #available(iOS 10.0, *) {
				UISelectionFeedbackGenerator().selectionChanged()
			}
			#endif
			return
		}
		
		#if canImport(Haptica)
		Haptic.impact(.light).generate()
		#else
		if #available(iOS 10.0, *) {
			UIImpactFeedbackGenerator(style: .light).impactOccurred()
		}
		#endif
		
		self.animatingVolumeChange = true
		self.animate()
	}
	
	private func animate() {
		let transformation = self.animationTransformation(for: self.options.animationStyle)
		transformation.preAnimationStuff()
		self.volumeHUDWindow?.isHidden = false
		UIView.animate(withDuration: transformation.animationTime, delay: 0,
					   usingSpringWithDamping: 0.5, initialSpringVelocity: 3,
					   options: transformation.options, animations: {
						if let transform = transformation.transform {
							self.transform = transform
						}
						transformation.animationStuff()
		}, completion: { completed in
			guard completed else {
				return
			}
			self.animateCompletion()
		})
	}
	
	private func animateCompletion() {
		let defaultTransformation = self.defaultTransformation(for: self.options.animationStyle)
		defaultTransformation.preAnimationStuff()
		let delay: Double = 1.4 * pow(10, 9)
		let delayDispatchTime = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + UInt64(delay))
		DispatchQueue.main.asyncAfter(deadline: delayDispatchTime) {
			UIView.animate(withDuration: defaultTransformation.animationTime, delay: 0,
						   options: defaultTransformation.options, animations: {
				if let transform = defaultTransformation.transform {
					self.transform = transform
				}
				defaultTransformation.animationStuff()
			}, completion: { completed in
				guard completed else {
					return
				}
				defaultTransformation.completionStuff()
				self.animatingVolumeChange = false
				self.volumeHUDWindow?.isHidden = true
			})
		}
	}
	
	// MARK: - Details
	
	private struct Transformation {
		
		let initialTransform: CGAffineTransform?
		var transform: CGAffineTransform?
		let options: UIView.AnimationOptions
		
		var preAnimationStuff: () -> Void = {}
		var animationStuff: () -> Void = {}
		var completionStuff: () -> Void = {}
		
		var animationTime = 0.2
		
		init(initialTransform: CGAffineTransform, options: UIView.AnimationOptions) {
			self.initialTransform = initialTransform
			self.transform = initialTransform
			self.options = options
		}
		
		init(transform: CGAffineTransform?, options: UIView.AnimationOptions) {
			self.transform = transform
			self.options = options
			self.initialTransform = nil
		}
	}
	
	private func defaultTransformation(for animationStyle: SideVolumeHUD.Option.AnimationStyle) -> Transformation {
		switch animationStyle {
		case .enlarge:
			var transformation = Transformation(initialTransform: CGAffineTransform(scaleX: 1, y: 0), options: [.curveEaseIn])
			transformation.transform = CGAffineTransform(scaleX: 1, y: 0.001)
			transformation.completionStuff = {
				self.transform = CGAffineTransform(scaleX: 1, y: 0)
			}
			return transformation
		case .slideLeftRight:
			let translationX = -(SideVolumeHUDHolderView.width + SideVolumeHUDHolderView.leading)
			return Transformation(initialTransform: CGAffineTransform(translationX: translationX, y: 0),
								  options: [.curveEaseIn])
		case .fadeInOut:
			var transformation = Transformation(initialTransform: CGAffineTransform(scaleX: 0, y: 0),
												options: [.transitionCrossDissolve])
			transformation.transform = nil
			transformation.animationTime = 0.2
			transformation.animationStuff = {
				self.alpha = 0.001
			}
			transformation.completionStuff = {
				self.transform = CGAffineTransform(scaleX: 0, y: 0)
			}
			return transformation
		}
	}
	
	private func animationTransformation(for animationStyle: SideVolumeHUD.Option.AnimationStyle) -> Transformation {
		switch animationStyle {
		case .enlarge:
			return Transformation(transform: CGAffineTransform(scaleX: 1, y: 1), options: [.allowUserInteraction])
		case .slideLeftRight:
			return Transformation(transform: CGAffineTransform(translationX: 0, y: 0), options: [.allowUserInteraction])
		case .fadeInOut:
			var transformation = Transformation(transform: nil, options: [.transitionCrossDissolve])
			transformation.animationTime = 0.7
			transformation.preAnimationStuff = {
				self.alpha = 0.001
				self.transform = CGAffineTransform(scaleX: 1, y: 1)
			}
			transformation.animationStuff = {
				self.alpha = 1
			}
			return transformation
		}
	}
	
	private func addSpecialEffects() {
		self.addParallaxToView()
		let notDarkStyle: UIBlurEffect.Style
		if #available(iOS 10.0, *) {
			notDarkStyle = .prominent
		} else {
			notDarkStyle = .light
		}
		self.addBlurBackground(style: self.options.theme == .dark ? .dark : notDarkStyle, belowSubview: self.subviews.first)
		self.round(corners: .allCorners, radius: 15)
	}
}

fileprivate extension UIView {
	
	func addParallaxToView(effectAmmount amount: Int = 15) {
		
		let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
		horizontal.minimumRelativeValue = -amount
		horizontal.maximumRelativeValue = amount
		
		let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
		vertical.minimumRelativeValue = -amount
		vertical.maximumRelativeValue = amount
		
		let group = UIMotionEffectGroup()
		group.motionEffects = [horizontal, vertical]
		self.addMotionEffect(group)
	}
	
	func addBlurBackground(style: UIBlurEffect.Style = .dark, belowSubview subview: UIView? = nil) {
		let blurEffect = UIBlurEffect(style: style)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = self.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		if let subview = subview {
			self.insertSubview(blurEffectView, belowSubview: subview)
		} else {
			self.addSubview(blurEffectView)
		}
	}
	
	func round(corners: UIRectCorner = .allCorners, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
								cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		self.layer.mask = mask
	}
}

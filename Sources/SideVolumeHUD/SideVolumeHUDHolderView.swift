//  SideVolumeHUD.swift
//  by Daniel Illescas Romero
//  Github: @illescasDaniel
//  License: MIT

import UIKit

#if canImport(Haptica)
import Haptica
#endif

fileprivate extension Notification.Name {
	fileprivate enum AVSystemController {
		static let AudioVolumeNoficationParameter = Notification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification")
	}
}

class SideVolumeHUDHolderView: UIView {
	
	private static var (leading_, top_, height_, width_): (CGFloat,CGFloat,CGFloat,CGFloat) = (15, 95, 160, 50)
	private weak var volumeHUDWindow: UIWindow?
	private var animationStyle: SideVolumeHUD.AnimationStyle = .fadeInOut
	private var orientationIsPortrait = false
	
	convenience init(withStyle animationStyle: SideVolumeHUD.AnimationStyle, hudWindow: UIWindow?, portrait: Bool = true) {
		self.init()
		self.orientationIsPortrait = portrait
		if !portrait {
			(SideVolumeHUDHolderView.leading_, SideVolumeHUDHolderView.top_, SideVolumeHUDHolderView.height_, SideVolumeHUDHolderView.width_)
				= (SideVolumeHUDHolderView.top_, SideVolumeHUDHolderView.leading_, SideVolumeHUDHolderView.width_, SideVolumeHUDHolderView.height_)
		}
		self.frame = CGRect(x: SideVolumeHUDHolderView.leading_, y: SideVolumeHUDHolderView.top_, width: SideVolumeHUDHolderView.width_, height: SideVolumeHUDHolderView.height_)
		self.animationStyle = animationStyle
		self.setupView()
		self.setupNotifications()
		self.volumeHUDWindow = hudWindow
		self.setupVolumeView(portrait: portrait)
	}
	private override init(frame: CGRect) {
		super.init(frame: frame)
		if frame != .zero {
			self.setupView()
			self.setupNotifications()
			self.setupVolumeView()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupView()
		self.setupNotifications()
		self.setupVolumeView()
	}
	
	// MARK: - Convenince
	
	func configure(for view: UIView) {
		self.setupConstraints(for: view)
	}
	
	private func setupView() {
		self.backgroundColor = .darkGray
		self.clipsToBounds = true
		self.layer.cornerRadius = 15
		if let transform = self.defaultTransformation(for: self.animationStyle).initialTransform {
			self.transform = transform
		}
	}
	
	private func setupNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.volumeDidChange), name: Notification.Name.AVSystemController.AudioVolumeNoficationParameter, object: nil)
	}
	
	private func setupConstraints(for view: UIView) {
		let margins = view.safeAreaLayoutGuide
		view.addSubview(self)
		self.translatesAutoresizingMaskIntoConstraints = false
		if self.orientationIsPortrait {
			self.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: SideVolumeHUDHolderView.leading_).isActive = true
			self.topAnchor.constraint(equalTo: margins.topAnchor, constant: SideVolumeHUDHolderView.top_).isActive = true
		} else {
			self.leadingAnchor.constraint(equalTo: margins.centerXAnchor, constant: -(SideVolumeHUDHolderView.width_ / 2)).isActive = true
			self.topAnchor.constraint(equalTo: margins.topAnchor, constant: SideVolumeHUDHolderView.top_).isActive = true
		}
		self.heightAnchor.constraint(equalToConstant: SideVolumeHUDHolderView.height_).isActive = true
		self.widthAnchor.constraint(equalToConstant: SideVolumeHUDHolderView.width_).isActive = true
		self.layer.zPosition = 1
	}
	
	private func setupVolumeView(portrait: Bool = true) {
		let volumeView = SideVolumeHUDView(frame: self.bounds, portrait: portrait)
		volumeView.tag = 10
		self.addSubview(volumeView)
	}

	private var animatingVolumeChange = false
	
	@objc private func volumeDidChange() {
		
		guard !self.animatingVolumeChange else {
			#if canImport(Haptica)
			Haptic.selection.generate()
			#else
			UISelectionFeedbackGenerator().selectionChanged()
			#endif
			return
		}
		
		#if canImport(Haptica)
		Haptic.impact(.light).generate()
		#else
		UIImpactFeedbackGenerator(style: .light).impactOccurred()
		#endif
		
		self.animatingVolumeChange = true
		self.animate()
	}
	
	private func animate() {
		let transformation = self.animationTransformation(for: self.animationStyle)
		transformation.preAnimationStuff()
		self.volumeHUDWindow?.isHidden = false
		UIView.animate(withDuration: transformation.animationTime, delay: 0, usingSpringWithDamping: 0.5,initialSpringVelocity: 3,
					   options: transformation.options, animations: {
			if let transform = transformation.transform {
				self.transform = transform
			}
			transformation.animationStuff()
		}, completion: { completed in
			guard completed else { return }
			self.animateCompletion()
		})
	}
	
	private func animateCompletion() {
		let defaultTransformation = self.defaultTransformation(for: self.animationStyle)
		defaultTransformation.preAnimationStuff()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1400)) { //Async.main(after: 1.4) {
			UIView.animate(withDuration: defaultTransformation.animationTime, delay: 0, options: defaultTransformation.options, animations: {
				if let transform = defaultTransformation.transform {
					self.transform = transform
				}
				defaultTransformation.animationStuff()
			}, completion: { completed in
				guard completed else { return }
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

	private func defaultTransformation(for animationStyle: SideVolumeHUD.AnimationStyle) -> Transformation  {
		switch animationStyle {
		case .enlarge:
			var transformation = Transformation(initialTransform: CGAffineTransform(scaleX: 1, y: 0), options: [.curveEaseIn])
			transformation.transform = CGAffineTransform(scaleX: 1, y: 0.001)
			transformation.completionStuff = {
				self.transform = CGAffineTransform(scaleX: 1, y: 0)
			}
			return transformation
		case .slideLeftRight:
			return Transformation(initialTransform: CGAffineTransform(translationX: -(SideVolumeHUDHolderView.width_ + SideVolumeHUDHolderView.leading_), y: 0), options: [.curveEaseIn])
		case .fadeInOut:
			var transformation = Transformation(initialTransform: CGAffineTransform(scaleX: 0, y: 0), options: [.transitionCrossDissolve])
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
	
	private func animationTransformation(for animationStyle: SideVolumeHUD.AnimationStyle) -> Transformation {
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
}


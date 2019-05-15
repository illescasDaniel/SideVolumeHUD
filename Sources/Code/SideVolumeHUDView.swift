//  SideVolumeHUDView.swift
//  by Daniel Illescas Romero
//  Github: @illescasDaniel
//  License: MIT

//import MediaPlayer

#if canImport(FontAwesome)
import FontAwesome
#endif

class SideVolumeHUDView: MPVolumeView {
	
	private let myBundle = Bundle(for: SideVolumeHUDView.self)
	
	convenience init(frame: CGRect, portrait: Bool, theme: SideVolumeHUD.Option.Theme) {
		self.init()
		self.frame = frame
		self.setupVolumeView(portrait: portrait, theme: theme)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		if frame != .zero {
			self.setupVolumeView()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupVolumeView()
	}
	
	func setupVolumeView(portrait: Bool = true, theme: SideVolumeHUD.Option.Theme = .dark) {
		let iconsColor: UIColor = theme == .dark ? .white : UIColor.darkGray.withAlphaComponent(0.85)
		
		let miniThumbImage = self.miniThumbImage(for: theme)
		var minVolumeImage = self.minVolumeImage(for: theme, color: iconsColor)
		var maxVolumeImage = self.maxVolumeImage(for: theme, color: iconsColor)
		
		if portrait {
			minVolumeImage = minVolumeImage.rotated(.right)
			maxVolumeImage = maxVolumeImage.rotated(.right)
		}
		
		self.showsRouteButton = false
		self.clipsToBounds = true
		
		if portrait {
			self.bounds = CGRect(x: 0, y: 0, width: self.bounds.height * 0.85, height: 20)
			self.transform = CGAffineTransform.identity.rotated(by: -CGFloat.pi / 2)
		} else {
			self.bounds = CGRect(x: 0, y: 0, width: self.bounds.width * 0.85, height: 20)
			self.transform = CGAffineTransform.identity
		}
		self.tintColor = .white
		self.setVolumeThumbImage(miniThumbImage, for: .normal)
		if let slider = self.subviews.first as? UISlider {
			slider.maximumValueImage = maxVolumeImage
			slider.minimumValueImage = minVolumeImage
		}
	}
	
	private func miniThumbImage(for theme: SideVolumeHUD.Option.Theme) -> UIImage {
		let dotColor: UIColor = theme == .dark ? .white : UIColor.darkGray
		#if canImport(FontAwesome)
		return UIImage.fontAwesomeIcon(name: .circle, style: .solid,
													 textColor: dotColor,
													 size: CGSize(width: 15, height: 15))
		#else
		let image = UIImage(named: "SideVolumeHUD/dotIcon", in: myBundle, compatibleWith: nil)
		return (image ?? UIImage()).resize(to: 15, withColor: dotColor)
		#endif
	}
	
	private func minVolumeImage(for theme: SideVolumeHUD.Option.Theme, color: UIColor) -> UIImage {
		#if canImport(FontAwesome)
		return UIImage.fontAwesomeIcon(name: .volumeDown, style: .solid,
									 textColor: color,
									 size: CGSize(width: 20, height: 20))
		#else
		let image = UIImage(named: "SideVolumeHUD/minVolumeIcon", in: myBundle, compatibleWith: nil)
		return (image ?? UIImage()).resize(to: 20, withColor: color)
		#endif
	}
	
	private func maxVolumeImage(for theme: SideVolumeHUD.Option.Theme, color: UIColor) -> UIImage {
		#if canImport(FontAwesome)
		return UIImage.fontAwesomeIcon(name: .volumeUp, style: .solid,
									 textColor: color,
									 size: CGSize(width: 20, height: 20))
		#else
		let image = UIImage(named: "SideVolumeHUD/maxVolumeIcon", in: myBundle, compatibleWith: nil)
		return (image ?? UIImage()).resize(to: 20, withColor: color)
		#endif
	}
}

// MARK: - Details

fileprivate extension BinaryFloatingPoint {
	var inRadians: Self {
		return (.pi * self) / 180.0
	}
}

private enum Direction: CGFloat {
	case right = 90
	case left = -90
	case flipped = 180
}

fileprivate extension UIImage {
	
	func rotated(_ direction: Direction) -> UIImage {
		let degrees = direction.rawValue
		guard Int(degrees) % 360 != 0, let cgImage = cgImage else {
			return self
		}
		
		if #available(iOS 10.0, *) {
			let renderer = UIGraphicsImageRenderer(size: self.size)
			return renderer.image { context in
				
				let radians = degrees.inRadians
				let newSize = (Int(degrees) % 180 == 0) ? self.size : CGSize(width: size.height, height: size.width)
				
				let ctx = context.cgContext
				ctx.translateBy(x: newSize.width / 2, y: newSize.height / 2)
				ctx.rotate(by: radians)
				
				let origin = CGPoint(x: -(self.size.width / 2), y: -(self.size.height / 2))
				let rect = CGRect(origin: origin, size: self.size)
				ctx.draw(cgImage, in: rect)
			}
		} else {
			var newImage: UIImage = self
			UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
			if let ctx = UIGraphicsGetCurrentContext() {
				
				let radians = degrees.inRadians
				let newSize = (Int(degrees) % 180 == 0) ? self.size : CGSize(width: size.height, height: size.width)
				
				ctx.translateBy(x: newSize.width / 2, y: newSize.height / 2)
				ctx.rotate(by: radians)
				
				let origin = CGPoint(x: -(self.size.width / 2), y: -(self.size.height / 2))
				let rect = CGRect(origin: origin, size: self.size)
				ctx.draw(cgImage, in: rect)
				
				if let img = ctx.makeImage() {
					newImage = UIImage(cgImage: img)
				}
				UIGraphicsEndImageContext()
			}
			return newImage
		}
	}
	
	#if !canImport(FontAwesome)
	func resize(to newWidth: CGFloat, withColor color: UIColor? = nil) -> UIImage {
		
		let scale = newWidth / self.size.width
		let newHeight = self.size.height * scale
		let newSize = CGSize(width: newWidth, height: newHeight)
		
		if #available(iOS 10.0, *) {
			guard let cgImage = self.cgImage else {
				return self
			}
			let renderer = UIGraphicsImageRenderer(size: newSize)
			return renderer.image { (context) in
				
				let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: newSize)
				
				if let color = color {
					color.setFill()
					let ctx = context.cgContext
					ctx.clip(to: rect, mask: cgImage)
					ctx.fill(rect)
				}
				
				self.draw(in: rect)
			}
		} else {
			// it's blurry but ok :/
			var newImage: UIImage = self
			guard let cgImage = self.cgImage else {
				return self
			}
			UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
			if let ctx = UIGraphicsGetCurrentContext() {
				
				ctx.interpolationQuality = .high
				
				let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: newSize)
				
				if let color = color {
					color.setFill()
					ctx.clip(to: rect, mask: cgImage)
					ctx.fill(rect)
				}
				
				self.draw(in: rect)
				
				if let img = ctx.makeImage() {
					newImage = UIImage(cgImage: img)
				}
				UIGraphicsEndImageContext()
			}
			return newImage
		}
	}
	#endif
}

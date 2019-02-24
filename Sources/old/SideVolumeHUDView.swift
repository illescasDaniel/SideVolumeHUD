//  SideVolumeView.swift
//  by Daniel Illescas Romero
//  Github: @illescasDaniel
//  License: MIT

import MediaPlayer

#if canImport(FontAwesome)
import FontAwesome
#endif

class SideVolumeHUDView: MPVolumeView {
	
	convenience init(frame: CGRect, portrait: Bool) {
		self.init()
		self.frame = frame
		self.setupVolumeView(portrait: portrait)
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
	
	func setupVolumeView(portrait: Bool = true) {
		
		#if canImport(FontAwesome)
		let miniThumbImage = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: .white, size: CGSize(width: 15, height: 15))
		#else
		let miniThumbImage = UIImage(imageLiteralResourceName: "dotIcon").resize(to: 15, withColor: .white)
		#endif
		
		#if canImport(FontAwesome)
		var minVolumeImage = UIImage.fontAwesomeIcon(name: .volumeDown, style: .solid, textColor: .white, size: CGSize(width: 20, height: 20))
		#else
		var minVolumeImage = UIImage(imageLiteralResourceName: "minVolumeIcon").resize(to: 20, withColor: .white)
		#endif
		
		#if canImport(FontAwesome)
		var maxVolumeImage = UIImage.fontAwesomeIcon(name: .volumeUp, style: .solid, textColor: .white, size: CGSize(width: 20, height: 20))
		#else
		var maxVolumeImage = UIImage(imageLiteralResourceName: "maxVolumeIcon").resize(to: 20, withColor: .white)
		#endif
		
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
}

// MARK: - Details

fileprivate extension BinaryFloatingPoint {
	var inRadians: Self {
		return (.pi * self) / 180.0
	}
}

fileprivate enum Direction: CGFloat {
	case right = 90
	case left = -90
	case flipped = 180
}

fileprivate extension UIImage {
	
	fileprivate func rotated(_ direction: Direction) -> UIImage {
		let degrees = direction.rawValue
		guard Int(degrees) % 360 != 0, let cgImage = cgImage else {
			return self
		}
		
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
	}
	

	/*fileprivate func scaleImage(toSize newSize: CGSize) -> UIImage? {
		var newImage: UIImage?
		let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
		UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
		if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
			context.interpolationQuality = .high
			let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
			context.concatenate(flipVertical)
			context.draw(cgImage, in: newRect)
			if let img = context.makeImage() {
				newImage = UIImage(cgImage: img)
			}
			UIGraphicsEndImageContext()
		}
		return newImage
	}*/
	#if !canImport(FontAwesome)
	fileprivate func resize(to newWidth: CGFloat, withColor color: UIColor? = nil) -> UIImage {
		let scale = newWidth / self.size.width
		let newHeight = self.size.height * scale
		let newSize = CGSize(width: newWidth, height: newHeight)
		
		let renderer = UIGraphicsImageRenderer(size: newSize)
		
		let image = renderer.image { (context) in
			
			let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: newSize)
			
			if let color = color {
				color.setFill()
				let ctx = context.cgContext
				ctx.clip(to: rect, mask: self.cgImage!)
				ctx.fill(rect)
			}
			UIColor.white.setFill()
			
			self.draw(in: rect)
		}
		return image
	}
	#endif
}

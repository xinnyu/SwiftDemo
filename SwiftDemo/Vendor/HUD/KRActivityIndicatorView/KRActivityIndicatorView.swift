//
//  KRProgressIndicator.swift
//  KRProgressIndicator
//
//  Copyright © 2016年 Krimpedance. All rights reserved.
//

import UIKit

/**
 *  KRActivityIndicatorView is a simple and customizable activity indicator
 */
@IBDesignable
public final class KRActivityIndicatorView: UIView {
    /// Activity indicator's head color (read-only).
    /// If you change color, change activityIndicatorViewStyle property.
    @IBInspectable public fileprivate(set) var headColor: UIColor = UIColor.black {
        willSet {
            if largeStyle {
                activityIndicatorViewStyle = .largeColor(newValue, tailColor)
            } else {
                activityIndicatorViewStyle = .color(newValue, tailColor)
            }
        }
    }

    /// Activity indicator's tail color (read-only).
    /// If you change color, change activityIndicatorViewStyle property.
    @IBInspectable public fileprivate(set) var tailColor: UIColor = UIColor.lightGray {
        willSet {
            if largeStyle {
                activityIndicatorViewStyle = .largeColor(headColor, newValue)
            } else {
                activityIndicatorViewStyle = .color(headColor, newValue)
            }
        }
    }

    /// Size of activity indicator. (`true` is large)
    @IBInspectable public var largeStyle: Bool = false {
        willSet {
            if newValue {
                activityIndicatorViewStyle.sizeToLarge()
            } else {
                activityIndicatorViewStyle.sizeToDefault()
            }
        }
    }

    /// Animation of activity indicator when it's shown.
    @IBInspectable public var animating: Bool = true

    /// calls `setHidden` when call `stopAnimating()`
    @IBInspectable public var hidesWhenStopped: Bool = false

    /// Activity indicator color style.
    public var activityIndicatorViewStyle: KRActivityIndicatorViewStyle = .black {
        didSet { setNeedsDisplay() }
    }

    /// Whether view performs animation
    public var isAnimating: Bool {
        if animationLayer.animation(forKey: "rotate") != nil {
            return true
        } else {
            return false
        }
    }

    fileprivate var animationLayer = CALayer()


    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    }

    /**
     Initializes and returns a newly allocated view object with the specified position.
     An initialized view object or nil if the object couldn't be created.

     - parameter position: Object position. Object size is determined automatically.
     - parameter activityIndicatorStyle:    Activity indicator default color use of KRActivityIndicatorViewStyle
     */
    public convenience init(position: CGPoint, activityIndicatorStyle style: KRActivityIndicatorViewStyle) {
        if style.isLargeStyle {
            self.init(frame: CGRect(x: position.x, y: position.y, width: 50, height: 50))
        } else {
            self.init(frame: CGRect(x: position.x, y: position.y, width: 20, height: 20))
        }

        activityIndicatorViewStyle = style
        backgroundColor = UIColor.clear
    }


    public override func draw(_ rect: CGRect) {
        // recreate AnimationLayer
        animationLayer.removeFromSuperlayer()
        animationLayer = CALayer()

        if activityIndicatorViewStyle.isLargeStyle {
            animationLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        } else {
            animationLayer.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }

        animationLayer.position = CGPoint(x: layer.position.x-layer.frame.origin.x, y: layer.position.y-layer.frame.origin.y)
        layer.addSublayer(animationLayer)

        // draw ActivityIndicator
        let colors: [CGColor] = activityIndicatorViewStyle.getGradientColors()
        let paths: [CGPath] = activityIndicatorViewStyle.getPaths()

        for i in 0..<8 {
            let pathLayer = CAShapeLayer()
            pathLayer.frame = animationLayer.bounds
            pathLayer.fillColor = colors[i]
            pathLayer.lineWidth = 0
            pathLayer.path = paths[i]
            animationLayer.addSublayer(pathLayer)
        }

        // animation
        if animating { startAnimating() }
    }
}


extension KRActivityIndicatorView {
    public func startAnimating() {
        if let _ = animationLayer.animation(forKey: "rotate") { return }

        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 1.1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float(NSIntegerMax)
        animation.fillMode = kCAFillModeForwards
        animation.autoreverses = false

        animationLayer.isHidden = false
        animationLayer.add(animation, forKey: "rotate")
    }

    public func stopAnimating() {
        animationLayer.removeAllAnimations()

        if hidesWhenStopped {
            animationLayer.isHidden = true
        }
    }
}

//
//  JSButton.swift
//  JSMaterialKit
//
//  Created by Jaxon Stevens on 04/20/15
//  Copyright (c) 2014 Jaxon Stevens. All rights reserved.
//


// Here is the place where we make those cool annimations. 
import UIKit

@IBDesignable
class JSButton : UIButton
{
    @IBInspectable var maskEnabled: Bool = true {
        didSet {
            jsLayer.enableMask(maskEnabled)
        }
    }
    @IBInspectable var rippleLocation: JSRippleLocation = .TapLocation {
        didSet {
            jsLayer.rippleLocation = rippleLocation
        }
    }
    @IBInspectable var circleGrowRatioMax: Float = 0.9 {
        didSet {
            jsLayer.circleGrowRatioMax = circleGrowRatioMax
        }
    }
    @IBInspectable var backgroundLayerCornerRadius: CGFloat = 0.0 {
        didSet {
            jsLayer.setBackgroundLayerCornerRadius(backgroundLayerCornerRadius)
        }
    }
    // animations
    @IBInspectable var shadowAniEnabled: Bool = true
    @IBInspectable var backgroundAniEnabled: Bool = true {
        didSet {
            if !backgroundAniEnabled {
                jsLayer.enableOnlyCircleLayer()
            }
        }
    }
    @IBInspectable var aniDuration: Float = 0.65
    @IBInspectable var circleAniTimingFunction: JSTimingFunction = .Linear
    @IBInspectable var backgroundAniTimingFunction: JSTimingFunction = .Linear
    @IBInspectable var shadowAniTimingFunction: JSTimingFunction = .EaseOut
    
    @IBInspectable var cornerRadius: CGFloat = 2.5 {
        didSet {
            layer.cornerRadius = cornerRadius
            jsLayer.setMaskLayerCornerRadius(cornerRadius)
        }
    }
    // color
    @IBInspectable var circleLayerColor: UIColor = UIColor(white: 0.45, alpha: 0.5) {
        didSet {
            jsLayer.setCircleLayerColor(circleLayerColor)
        }
    }
    @IBInspectable var backgroundLayerColor: UIColor = UIColor(white: 0.75, alpha: 0.25) {
        didSet {
            jsLayer.setBackgroundLayerColor(backgroundLayerColor)
        }
    }
    override var bounds: CGRect {
        didSet {
            jsLayer.superLayerDidResize()
        }
    }
    
    private lazy var jsLayer: JSLayer = JSLayer(superLayer: self.layer)
    
    // MARK - initilization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupLayer()
    }
    
    // MARK - setup methods
    private func setupLayer() {
        adjustsImageWhenHighlighted = false
        self.cornerRadius = 2.5
        jsLayer.setBackgroundLayerColor(backgroundLayerColor)
        jsLayer.setCircleLayerColor(circleLayerColor)
    }
   
    // MARK - location tracking methods
     override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if rippleLocation == .TapLocation {
            jsLayer.didChangeTapLocation(touch.locationInView(self))
        }
        
        // circleLayer animation
        jsLayer.animateScaleForCircleLayer(0.45, toScale: 1.0, timingFunction: circleAniTimingFunction, duration: CFTimeInterval(aniDuration))
        
        // backgroundLayer animation
        if backgroundAniEnabled {
            jsLayer.animateAlphaForBackgroundLayer(backgroundAniTimingFunction, duration: CFTimeInterval(aniDuration))
        }
        
        // shadow animation for self
        if shadowAniEnabled {
            let shadowRadius = self.layer.shadowRadius
            let shadowOpacity = self.layer.shadowOpacity
            
            //if mkType == .Flat {
            //    jsLayer.animateMaskLayerShadow()
            //} else {
                jsLayer.animateSuperLayerShadow(10, toRadius: shadowRadius, fromOpacity: 0, toOpacity: shadowOpacity, timingFunction: shadowAniTimingFunction, duration: CFTimeInterval(aniDuration))
            //}
        }
        
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
}


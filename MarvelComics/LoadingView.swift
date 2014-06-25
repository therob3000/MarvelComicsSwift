//
//  LoadingView.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/14/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit
import QuartzCore


func rotationWithPerspective(perspective:Float, angle:Float, x:Float, y:Float, z:Float) -> CATransform3D {
    var transform:CATransform3D = CATransform3DIdentity;
    transform.m34 = perspective
    
    return CATransform3DRotate(transform, angle, x, y, z)
}

class LoadingView: UIView {

    init(frame: CGRect ,image:UIImage?) {
        super.init(frame: frame)
        self._configLayerWith(image)
    }
    
    func startAnimation(){
        var pausedTime:CFTimeInterval = self.layer.timeOffset
        
        self.layer.speed = 1.0
        self.layer.timeOffset = 0.0
        self.layer.beginTime = 0.0
        var timeSincePause:CFTimeInterval = self.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        self.layer.beginTime = timeSincePause;
    }
    
    func stopAnimation(){
        var pausedTime:CFTimeInterval = self.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        
        self.layer.speed = 0.0
        self.layer.timeOffset = pausedTime
    }
    
    func _configLayerWith(image:UIImage?){
        
        let layer:CALayer = CALayer()
        layer.contents = image?.CGImage
        layer.frame = CGRectInset(self.bounds, 1.0, 1.0);
        layer.shouldRasterize = true
        layer.masksToBounds = true
        self.layer.addSublayer(layer)
        self._configAnimationFor(layer)
    }
    
    func _configAnimationFor(layer:CALayer){
        let animation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        animation.removedOnCompletion = false
        animation.repeatCount = HUGE
        animation.duration = 1.2
        
        animation.timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        ]
        
        var perspective:Float = 1.0/120.0;
        
        animation.values = [
            NSValue(CATransform3D:CATransform3DScale(rotationWithPerspective(perspective, 3.14, 0, 0, 0), 0.5, 0.5, 0.5)),
            NSValue(CATransform3D:CATransform3DScale(rotationWithPerspective(perspective, 3.14, 0, 1, 0), 1, 1, 1)),
            NSValue(CATransform3D:CATransform3DScale(rotationWithPerspective(perspective, 3.14, 0, 0, 1), 0.5, 0.5, 0.5))
        ]
        
        layer.addAnimation(animation, forKey: "MarvelComics-Loading")
        
        self.stopAnimation()
    }


}

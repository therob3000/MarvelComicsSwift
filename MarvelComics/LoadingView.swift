//
//  LoadingView.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/14/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit
import QuartzCore


func rotationWithPerspective(perspective:CGFloat, angle:CGFloat, x:CGFloat, y:CGFloat, z:CGFloat) -> CATransform3D {
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
    
    private func _configLayerWith(image:UIImage?){
        
        let layer:CALayer = CALayer()
        //layer.contents = image?.CGImage
        layer.frame = CGRectInset(self.bounds, 1.0, 1.0);
        layer.shouldRasterize = true
        layer.masksToBounds = true
        self.layer.addSublayer(layer)
        self._configAnimation()
    }
    
    private func _configAnimation() {
        
        let beginTime:CFTimeInterval = CACurrentMediaTime() + 1.2
        let barWidth = CGRectGetWidth(self.bounds) / 5.0;
        
        for  i in 0...4 {
            
            let layer = CALayer()
            layer.backgroundColor = UIColor.whiteColor().CGColor
            layer.frame = CGRectMake(barWidth * CGFloat(i), 0.0, barWidth - 3.0, CGRectGetHeight(self.bounds));
            layer.cornerRadius = layer.frame.width / 2
            layer.transform = CATransform3DMakeScale(1.0, 0.3, 0.0);
            
            let anim = CAKeyframeAnimation(keyPath:"transform");
            
            anim.removedOnCompletion = false;
            
            anim.beginTime = beginTime - (1.2 - (0.1 * CFTimeInterval(i)));
            anim.duration = 1.2;
            anim.repeatCount = HUGE;
            
            anim.keyTimes = [0.0, 0.2, 0.4, 1.0];
            
            anim.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            ]
            
            anim.values = [
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 0.4, 0.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 0.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 0.4, 0.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 0.4, 0.0))
            ]
            
            
            self.layer.addSublayer(layer);
            layer.addAnimation(anim, forKey: "MarvelComics-Loading");

        }
        
        self.stopAnimation()
    }

}

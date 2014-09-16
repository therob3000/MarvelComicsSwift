//
//  UIViewController+Loader.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/16/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

var _blurView:UIVisualEffectView? = nil

extension UIViewController {
    
    var blurView : UIVisualEffectView? {
    get {
        return _blurView
    }
    set {
        _blurView = newValue
    }
    }
    
    func showLoadingView(){
        
        if !(self.blurView != nil) {
            
            var loader:LoadingView = LoadingView(frame: CGRectMake(0, 0, 40, 40), image: UIImage(named: "captainamerica"))
            self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
            
            if self.navigationController == nil {
                self.blurView!.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 64)
            }else{
                self.blurView!.frame = self.view.bounds;
            }
            self.blurView!.contentView.addSubview(loader)
            
            loader.center = self.blurView!.center
            loader.startAnimation()
            
            self.view.addSubview(blurView!)
        }
        
        self.view.userInteractionEnabled = false
        self.blurView!.hidden = false
    }
    
    func hideLoadingView(){
        if (self.blurView != nil) {
            self.blurView!.hidden = true
            self.view.userInteractionEnabled = true
        }
    }
    
}
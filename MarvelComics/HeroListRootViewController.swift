//
//  HeroListRoot.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/18/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

class HeroListRootViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let blurView:UIVisualEffectView! = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        blurView.frame = self.view.bounds
        self.view.insertSubview(blurView, aboveSubview: self.imageView)
    }
    @IBAction func listButtonPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(SlideViewControllerShouldSlideNotification, object: nil)
    }
    
}

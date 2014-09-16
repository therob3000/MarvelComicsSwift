//
//  RefreshControll.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/14/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit
import QuartzCore

let kKVOKeyPathHidden = "hidden"

class RefreshControl: UIRefreshControl {

    var loadingView:LoadingView?
    var date:NSDate = NSDate()
    var tableView:UITableView?
    
    override init() {
        super.init()
        
        self.transform = CGAffineTransformMakeScale(0.0, 0.0)
        self.loadingView = LoadingView(frame: CGRectMake(0, 0, 30, 30), image: UIImage(named: "captainamerica"))
    
        self.tintColor = UIColor.clearColor()
        self.addSubview(self.loadingView!)
        
        self.loadingView!.center = self.center
        self.loadingView!.startAnimation()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        super.willMoveToSuperview(newSuperview)
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: nil, animations: {
                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
    }
    
}

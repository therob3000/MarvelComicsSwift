//
//  RefreshControll.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/14/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit
import QuartzCore

class RefreshControll: UIRefreshControl {

    var loadingView:LoadingView?
    var date:NSDate = NSDate()
    var tableView:UITableView?
    
    init() {
        super.init()
        
        self.loadingView = LoadingView(frame: CGRectMake(0, 0, 40, 40), image: UIImage(named: "captainamerica"))
        
        self.tintColor = UIColor.clearColor()
        self.addSubview(self.loadingView)
        
        self.loadingView!.center = self.center
        self.loadingView!.startAnimation()
    }
}

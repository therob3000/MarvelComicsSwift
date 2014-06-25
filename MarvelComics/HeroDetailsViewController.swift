//
//  HeroDetailsViewController.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/13/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

class HeroDetailsViewController: UIViewController {

    weak var loadingView:LoadingView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var view:LoadingView = LoadingView(frame: CGRectMake(100, 100, 40, 40),image: UIImage(named: "captainamerica"))
        self.loadingView = view
        self.view.addSubview(view)
        self.loadingView?.startAnimation()
    }

}

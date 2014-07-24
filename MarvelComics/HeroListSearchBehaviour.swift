//
//  HeroListSearchBehaviour.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 7/7/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

class HeroListSearchBehaviour: NSObject, UISearchBarDelegate {
   
    weak var targetViewController:UIViewController? = nil
    //     var isSearching:Bool
    
    init(targetViewController:UIViewController){
        super.init()
        
        self.targetViewController = targetViewController;
    }
    
}

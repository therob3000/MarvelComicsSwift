//
//  UIStoryboard+Utility.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/11/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import Foundation

extension UIStoryboard {
    
    class func mainStoryBoard () -> UIStoryboard? {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class func viewControllerWith(name:String!) -> UIViewController? {
        return UIStoryboard.mainStoryBoard()?.instantiateViewControllerWithIdentifier(name) as? UIViewController
    }
    
}
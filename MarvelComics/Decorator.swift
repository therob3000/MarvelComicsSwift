//
//  Decorator.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/14/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

class Decorator: NSObject {
   
    class func configAppearance(){
        //NSFontAttributeName
        var textAttributes:NSDictionary! = NSDictionary(objects: [UIColor.whiteColor(),self.regularFontWithSize(23.0)], forKeys:[NSForegroundColorAttributeName,NSFontAttributeName])
        
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barStyle = UIBarStyle.Black
        UINavigationBar.appearance().translucent = true
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
    }
    
    class func marvelBlue() -> UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    class func regularFontWithSize(size:CGFloat!) -> UIFont {
        return UIFont(name: "Resagokr", size: size)
    }
    
    class func lightFontWithSize(size:CGFloat!) -> UIFont {
        return UIFont(name: "ResagokrLight", size: size)
    }
    
    class func boldFontWithSize(size:CGFloat!) -> UIFont {
        return UIFont(name: "ResagokrBold", size: size)
    }
    
}

//
//  AppDelegate.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/8/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        Decorator.configAppearance()
        MagicalRecord.setupCoreDataStackWithInMemoryStore()
        return true
    }

}


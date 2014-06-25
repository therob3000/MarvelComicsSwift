//
//  SlideViewController.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/24/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

let SlideViewControllerShouldSlideNotification:String = "SlideViewControllerShouldSlideNotification"

class SlideViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var containerView: UIView
    @IBOutlet var tableView: UITableView
    
    
    var didSlided:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._registrNotifications()
        self.tableView.contentInset = UIEdgeInsetsMake((self.view.frame.size.height - 400) / 2, 0, 0, 0)
    }
    
    //Private
    
    func _registrNotifications(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("shouldSlide"), name: SlideViewControllerShouldSlideNotification, object: nil)
        
    }
    
    //sliding methods
    
    func shouldSlide() {
        
        if self.didSlided {
            self.slideBack()
        } else {
            self.slideOut()
        }
        
    }
    
    func slideOut() {
        UIView.animateWithDuration(0.3, animations: {
            
            self.didSlided = true
            
            self.containerView.transform = CGAffineTransformMakeScale(0.5, 0.5)
            self.containerView.center = CGPointMake(self.view.center.x + self.view.frame.size.width / 2
                , self.view.center.y)
            
            })
    }
    
    func slideBack() {
        
        self.didSlided = false
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.containerView.transform = CGAffineTransformMakeScale(1, 1)
            self.containerView.center = CGPointMake(self.view.center.x
                , self.view.center.y)
            
            })
    }
    
    
    //UITableViewDataSource
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if !cell {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        cell!.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255, alpha: 1)
        cell!.textLabel.text = "Item \(indexPath.row)"
        
        
        return cell;
    }

}

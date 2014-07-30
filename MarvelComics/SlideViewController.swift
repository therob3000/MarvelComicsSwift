//
//  SlideViewController.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/24/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

let SlideViewControllerShouldSlideNotification:String = "SlideViewControllerShouldSlideNotification"
let SlideViewControllerDidSlideOutNotification:String = "SlideViewControllerDidSlideOutNotification"
let SlideViewControllerDidSlideBackNotification:String = "SlideViewControllerDidSlideBackNotification"

class SlideViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var containerView: UIView?
    @IBOutlet var tableView: UITableView?

    var didSlided:Bool = false
    var initialPosition:CGFloat = 0
    var gesureRecongniser:UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._configTableView()
        self._registrNotifications()
        self._registrGestureRecognizer()
    }
    
    //Private
    
    func _configTableView(){
        self.tableView!.transform = CGAffineTransformMakeScale(0.5, 0.5)
    }
    
    func _registrNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("slide"), name: SlideViewControllerShouldSlideNotification, object: nil)
        
    }
    
    func _registrGestureRecognizer() {
        self.gesureRecongniser = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        
        self.containerView!.addGestureRecognizer(self.gesureRecongniser)
    }
    
    func handlePan(sender:UIPanGestureRecognizer) {
        
        let velocity:CGPoint = sender.velocityInView(self.view)
        
        if ( sender.state == UIGestureRecognizerState.Began ) {
            
            self.initialPosition = sender.locationInView(self.view).x
            
        } else if ( sender.state == UIGestureRecognizerState.Changed ) {
            
            self.slideForTouchPosition(sender.locationInView(self.view), velocity: sender.velocityInView(self.containerView))
            
        } else if ( sender.state == UIGestureRecognizerState.Ended ) {
            if velocity.x > 0 {
                self.slideOut()
            } else if (!self.didSlided){
                self.slideBack()
            }
        }
        
    }
    
    
    //sliding methods
    
    func slide() {
        
        if self.didSlided {
            self.slideBack()
        } else {
            self.slideOut()
        }
        
    }
    
    func slideForTouchPosition(touchPosition:CGPoint, velocity:CGPoint) {

        if velocity.x > 0 {
            self.containerView!.center.x += touchPosition.x - self.initialPosition
        } else {
            self.didSlided = false
            
            if ((self.containerView!.frame.origin.x - self.initialPosition + touchPosition.x) < 0) { // to not show right edge
                return;
            }
            
            self.containerView!.center.x -= self.initialPosition - touchPosition.x
        }
        
        let scaleFactor:CGFloat = (self.view.frame.width * 2 - self.containerView!.frame.origin.x) / (self.view.frame.width * 2)

        self.tableView!.transform = CGAffineTransformMakeScale( 1.5 - scaleFactor, 1.5 - scaleFactor);
        self.containerView!.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        self.initialPosition = touchPosition.x
    }
    
    func slideOut() {
        UIView.animateWithDuration(0.3, animations: {
            
            self.didSlided = true
            self.containerView!.transform = CGAffineTransformMakeScale(0.5, 0.5)
            self.containerView!.center.x = self.view.center.x + self.view.frame.size.width * 0.6
            self.tableView!.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: { (completion:Bool) in
                NSNotificationCenter.defaultCenter().postNotificationName(SlideViewControllerDidSlideOutNotification, object: nil)
            });
    }
    
    func slideBack() {
        
        self.didSlided = false
        

        UIView.animateWithDuration(0.3, animations: {
            
            self.containerView!.transform = CGAffineTransformMakeScale(1, 1)
            self.containerView!.center = CGPointMake(self.view.center.x
                , self.view.center.y)
            self.tableView!.transform = CGAffineTransformMakeScale(0.5, 0.5)
            }, completion: { (completion:Bool) in
                NSNotificationCenter.defaultCenter().postNotificationName(SlideViewControllerDidSlideBackNotification, object: nil)
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

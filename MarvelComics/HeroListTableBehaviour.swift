//
//  HeroListTableBehaviour.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 7/7/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

class HeroListTableBehaviour: NSObject, UITableViewDelegate, UIScrollViewDelegate {
   
    weak var targetController:UIViewController?
    weak var targetTableView:UITableView?
         var previousIndexPath:NSIndexPath?
         var scrollDirection:Bool = true
         var previouseOffSetY:CGFloat = 0
         var shouldParalax:Bool = false
         var arrayDataSource:ArrayDataSource? = nil;
    
    init(targetTableView:UITableView, targetController:UIViewController, arrayDataSource:ArrayDataSource?){
        super.init()
        
        self.targetTableView = targetTableView
        self.targetTableView!.delegate = self
        self.targetController = targetController
        self.arrayDataSource = arrayDataSource;
    }
    
    //public
    
    func deselectCell(){
        var cell:UITableViewCell? = self.targetTableView?.cellForRowAtIndexPath(self.previousIndexPath)
        
        if cell {
            UIView.animateWithDuration(0.3, animations: {
                cell!.transform = CGAffineTransformMakeScale(1, 1)
                })
        }
    }
    
    //tableViewDelegate
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        var cell : UITableViewCell! = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(self.previousIndexPath?, animated: true)
        self.previousIndexPath = indexPath
        UIView.animateWithDuration(heroListSelectionAnimationDuration, animations: {
            cell.transform = CGAffineTransformMakeScale(heroListSelectionScaleFactor, heroListSelectionScaleFactor)
            }
            , completion: { (succes:Bool) in
                let viewController:UIViewController? = UIStoryboard.viewControllerWith("HeroDetailsViewController");
                self.targetController!.navigationController.pushViewController(viewController, animated: true)
            })
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!){
        
        var heroCell:HeroListCell = cell as HeroListCell
        
        if self.scrollDirection {
            heroCell.scrollView.contentOffset.y = -heroListCellMaxParalaxOffset
        }else{
            heroCell.scrollView.contentOffset.y = heroListCellMaxParalaxOffset
        }
        
    }
    
    
    //scrollViewDelegate
    
    func scrollViewDidScroll(tableView: UITableView!){
        
        let contentOffset = tableView.contentOffset.y
        let delta = (self.previouseOffSetY - contentOffset) / heroListParalaxRatio
        
        self.previouseOffSetY = contentOffset
        self.scrollDirection = delta > 0
        
        if self.shouldParalax {
            for cell : AnyObject in tableView.visibleCells() {
                let heroCell:HeroListCell = cell as HeroListCell
                
                heroCell.paralaxScrollingForDeleta(fabsf(CGFloat(delta)), scrollDirection: self.scrollDirection)
            }
        }
        
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView!, withVelocity velocity: CGPoint, targetContentOffset: CMutablePointer<CGPoint>){
        if (velocity.y > 0){
            
        }
    }
    
}

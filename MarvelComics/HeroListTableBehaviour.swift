//
//  HeroListTableBehaviour.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 7/7/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

class HeroListTableBehaviour: NSObject, UITableViewDelegate, UIScrollViewDelegate {
   
    //public
    var shouldParalax:Bool = false
    
    //private
    
    weak private var targetController:UITableViewController?
    weak private var targetTableView:UITableView?
    
         private var arrayDataSource:ArrayDataSource?;
         private var previousIndexPath:NSIndexPath?
         private var scrollDirection:Bool = true
         private var previouseOffSetY:CGFloat = 0
         private let pagination:PaginationBehaviour?
         private var isSearching:Bool = false
    
    init(targetController:UITableViewController){
        super.init()
        
        self.targetTableView = targetController.tableView
        self.targetTableView!.delegate = self
        self.targetController = targetController
        
        self.__setupDataSource()
        self.__setupRefreshControll()
        
        self.pagination = PaginationBehaviour(tableView: targetTableView, arrayDataSource: arrayDataSource)
    }
    
    //public
    
    func deselectCell(){
        
        if (self.previousIndexPath != nil) {
            
            var cell:UITableViewCell? = self.targetTableView?.cellForRowAtIndexPath(self.previousIndexPath!)
            UIView.animateWithDuration(0.3, animations: {
                cell!.transform = CGAffineTransformMakeScale(1, 1)
                })
        }
    }
    
    func loadDataFor(offset:String! = "0", searchString:String? = nil){
        
        Hero.getHeroesList(offset: "0",searchFragment:searchString, callback: {(heroes: [Hero]?, error: NSError?) in
            if (self.targetController?.refreshControl?.refreshing != nil) {
                self.targetController?.refreshControl?.endRefreshing()
            }
            if (error != nil) {
                println("Eroror \(error?.localizedDescription)")
            }else{
                self.__updateDataSourceWith(heroes!)
            }
            
        })
    }
    
    func loadData(){
        self.targetController?.refreshControl?.beginRefreshing()
        self.loadDataFor()
    }
    
    //private 
    
    
    private func __updateDataSourceWith(heroes:[Hero]) {
        
        var indexPaths:[NSIndexPath] = []
        
        for var index = 0; index < heroes.count; ++index {
            indexPaths.append(NSIndexPath(forRow: index, inSection: 0))
        }
        //
        //        if self.isSearching {
        //            self.searchHeroes = heroes
        //            self.arrayDataSource!.items = self.searchHeroes!
        //            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        //        }else{
        //self.heroes = heroes
        if (self.arrayDataSource != nil) {
            self.arrayDataSource?.addItems(heroes);
            self.targetTableView?.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        //        }
    }
    
    private func __setupDataSource(){
        self.arrayDataSource = ArrayDataSource(cellID: "HeroListCell", configureCellBlock: __configCell)
        self.targetTableView!.dataSource = self.arrayDataSource
    }
    
    private func __setupRefreshControll(){
        self.targetController!.refreshControl = RefreshControl()
        self.targetController!.refreshControl?.addTarget(self, action: Selector("loadData"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    private func __configCell(cell:UITableViewCell!, item:AnyObject!){
        (cell as HeroListCell).configCellWith(item as Hero)
    }
    
    //tableViewDelegate
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        var cell : UITableViewCell! = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(self.previousIndexPath!, animated: true)
        self.previousIndexPath = indexPath
        UIView.animateWithDuration(heroListSelectionAnimationDuration, animations: {
            cell.transform = CGAffineTransformMakeScale(heroListSelectionScaleFactor, heroListSelectionScaleFactor)
            }
            , completion: { (succes:Bool) in
                let viewController:UIViewController? = UIStoryboard.viewControllerWith("HeroDetailsViewController");
                
                if let targetViewController = self.targetController {
                    self.targetController?.navigationController?.pushViewController(viewController!, animated: true)
                }
                
            })
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!){
        
        var heroCell:HeroListCell = cell as HeroListCell
        
        if self.scrollDirection {
            heroCell.scrollView!.contentOffset.y = -heroListCellMaxParalaxOffset
        }else{
            heroCell.scrollView!.contentOffset.y = heroListCellMaxParalaxOffset
        }
        
    }
    
    
    //scrollViewDelegate
    
    func scrollViewDidScroll(tableView: UITableView!){
        
        let contentOffset = tableView.contentOffset.y
        let delta:CGFloat = (self.previouseOffSetY - contentOffset) / heroListParalaxRatio
        
        self.previouseOffSetY = contentOffset
        self.scrollDirection = delta > 0
        
        if self.shouldParalax {
            for cell : AnyObject in tableView.visibleCells() {
                let heroCell:HeroListCell = cell as HeroListCell
                
                heroCell.paralaxScrollingForDeleta(CGFloat(fabsf(CFloat(delta))), scrollDirection: self.scrollDirection)
            }
        }
        
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView!, withVelocity velocity: CGPoint, targetContentOffset: UnsafePointer<CGPoint>){
        if (velocity.y > 0){
            self.pagination?.performPaginationIfShouldFor(velocity)
        }
    }
    
}

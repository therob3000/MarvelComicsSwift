//
//  HeroesTableViewController.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/11/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit
import QuartzCore

let heroListParalaxRatio:CGFloat = 8
let heroListSelectionScaleFactor:CGFloat = 0.95
let heroListSelectionAnimationDuration:NSTimeInterval = 0.3

class HeroesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var heroes:Hero[]? = nil
    var searchHeroes:Hero[]? = nil
    var arrayDataSource:ArrayDataSource?
    var previousIndexPath:NSIndexPath? = nil
    var isSearching:Bool = false
    var searchString:String? = nil
    var loadingView:UIVisualEffectView? = nil
    var previouseOffSetY:CGFloat = 0
    var didAppear:Bool = false
    var scrollDirection:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self._setupDataSource()
        self._loadDataForOffset("0", searchString: nil)
        self._setupRefreshControll()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var cell:UITableViewCell? = self.tableView.cellForRowAtIndexPath(self.previousIndexPath)
        
        if cell {
            var engle : Float = 0
            UIView.animateWithDuration(0.3, animations: {
                cell!.transform = CGAffineTransformMakeScale(1, 1)
                })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.didAppear = true
    }
    
    func loadData(){
        self.refreshControl.beginRefreshing()
        self.tableView.exchangeSubviewAtIndex(0, withSubviewAtIndex: 1)
        self._loadDataForOffset("\(self.arrayDataSource?.items?.count)", searchString: nil)
    }
    
    //halpers
    
    func _setupRefreshControll(){
        
        self.refreshControl = RefreshControll()
        self.refreshControl.addTarget(self, action: Selector("loadData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.beginRefreshing()
    }
    
    func _setupDataSource(){
        self.arrayDataSource = ArrayDataSource(items: self.heroes, cellID: "HeroListCell", configureCellBlock: {(cell:UITableViewCell!, item:AnyObject!) in
            
            (cell as HeroListCell).configCellWith(item as Hero)
            
            })
        self.tableView.dataSource = self.arrayDataSource
    }
    
    func _updateDataSourceWith(heroes:Hero[]?) {
        
        var indexPaths:NSIndexPath[] = []
        
        for var index = 0; index < heroes?.count; ++index {
            indexPaths += NSIndexPath(forRow: index, inSection: 0)
        }
        
        if self.isSearching {
            self.searchHeroes = heroes
            self.arrayDataSource!.items = self.searchHeroes
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }else{
            self.heroes = heroes
            self.arrayDataSource!.items = self.heroes;
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

    func _loadDataForOffset(offset:String!, searchString:String?){
        
        Hero.getHeroesList(limit: "30", offset: "0",searchFragment:searchString, callback: {(heroes: Hero[]?, error: NSError?) in
            if self.refreshControl?.refreshing {
                self.refreshControl.endRefreshing()
            }
            if error {
                println("Eroror \(error?.localizedDescription)")
            }else{
                self._updateDataSourceWith(heroes)
            }
            
            })
    }
    
    //table view delegate
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        var cell : UITableViewCell! = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(self.previousIndexPath?, animated: true)
        self.previousIndexPath = indexPath
        UIView.animateWithDuration(heroListSelectionAnimationDuration, animations: {
            cell.transform = CGAffineTransformMakeScale(heroListSelectionScaleFactor, heroListSelectionScaleFactor)
            }
            , completion: { (succes:Bool) in
                let viewController:UIViewController? = UIStoryboard.viewControllerWith("HeroDetailsViewController");
                self.navigationController.pushViewController(viewController, animated: true)
            })
    }
    
    override func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!){
        
        var heroCell:HeroListCell = cell as HeroListCell
        
        if self.scrollDirection {
            heroCell.scrollView.contentOffset.y = -heroListCellMaxParalaxOffset
        }else{
            heroCell.scrollView.contentOffset.y = heroListCellMaxParalaxOffset
        }
        
    }
    
    //UIScrollViewDelegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView!){
        
        let contentOffset = scrollView.contentOffset.y
        let delta = (self.previouseOffSetY - contentOffset) / heroListParalaxRatio
        
        self.previouseOffSetY = contentOffset
        self.scrollDirection = delta > 0
        
        if self.didAppear {
            for cell : AnyObject in self.tableView.visibleCells() {
                let heroCell:HeroListCell = cell as HeroListCell
                
                heroCell.paralaxScrollingForDeleta(fabsf(CGFloat(delta)), scrollDirection: self.scrollDirection)
            }
        }
    
    }
    
    //UISearchDisplayDelegate
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar!) {
        searchBar.setShowsCancelButton(true, animated: true)
        self.isSearching = true
    }
    
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!){
        let count:Int = searchBar.text.utf16count
        self._loadDataForOffset("0", searchString: count > 0 ? searchBar.text : nil )
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar!){
        searchBar.setShowsCancelButton(false, animated: false)
        self.tableView.endEditing(true)
        searchBar.text = ""
        self.isSearching = false
        self._updateDataSourceWith(self.heroes)
    }
    
    
}

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
    var tableBehaviour:HeroListTableBehaviour? = nil
    
    //Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._registerNorifications()
        self._setupDataSource()
        self._setupTableBehaviour()
        self._loadDataForOffset("0", searchString: nil)
        self._setupRefreshControll()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableBehaviour!.deselectCell()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableBehaviour!.shouldParalax = true
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    //Notifications
    
    func _didSlideOut(){
        self.view.userInteractionEnabled = false
    }
    
    func _didSlideBack(){
        self.view.userInteractionEnabled = true
    }
    
    //halpers
    
    func loadData(){
        self.refreshControl.beginRefreshing()
        self._loadDataForOffset("\(self.arrayDataSource!.items.count)", searchString: nil)
    }
    
    func _registerNorifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("_didSlideOut"), name: SlideViewControllerDidSlideOutNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("_didSlideBack"), name: SlideViewControllerDidSlideBackNotification, object: nil);
    }
    
    func _setupRefreshControll(){
        
        self.refreshControl = RefreshControll()
        self.refreshControl.addTarget(self, action: Selector("loadData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.beginRefreshing()
    }
    
    func _setupDataSource(){
        self.arrayDataSource = ArrayDataSource(cellID: "HeroListCell", configureCellBlock: {(cell:UITableViewCell!, item:AnyObject!) in
            
            (cell as HeroListCell).configCellWith(item as Hero)
            
            })
        self.tableView.dataSource = self.arrayDataSource
    }
    
    func _setupTableBehaviour(){
        self.tableBehaviour = HeroListTableBehaviour(targetTableView: self.tableView, targetController: self, arrayDataSource: self.arrayDataSource);
    }
    
    func _updateDataSourceWith(heroes:Hero[]?) {
        
        var indexPaths:NSIndexPath[] = []
        
        for var index = 0; index < heroes?.count; ++index {
            indexPaths += NSIndexPath(forRow: index, inSection: 0)
        }
        
        if self.isSearching {
            self.searchHeroes = heroes
            self.arrayDataSource!.items = self.searchHeroes!
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }else{
            self.heroes = heroes
            self.arrayDataSource!.items = self.heroes!;
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

    func _loadDataForOffset(offset:String!, searchString:String?){
        
        Hero.getHeroesList(offset: "0",searchFragment:searchString, callback: {(heroes: Hero[]?, error: NSError?) in
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

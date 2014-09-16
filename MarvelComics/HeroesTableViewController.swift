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
    
    var heroes:[Hero]? = nil
    var searchHeroes:[Hero]? = nil
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
        self._setupTableBehaviour()
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
    
    func didSlideOut(){
        self.view.userInteractionEnabled = false
    }
    
    func didSlideBack(){
        self.view.userInteractionEnabled = true
    }
    
    //halpers
    
    private func _registerNorifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didSlideOut"), name: SlideViewControllerDidSlideOutNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didSlideBack"), name: SlideViewControllerDidSlideBackNotification, object: nil);
    }
    
    private func _setupTableBehaviour(){
        self.tableBehaviour = HeroListTableBehaviour(targetController: self);
        self.tableBehaviour!.loadDataFor()
    }
    
    //UISearchDisplayDelegate
//    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar!) {
//        searchBar.setShowsCancelButton(true, animated: true)
//        self.isSearching = true
//    }
//    
//    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!){
//        let count:Int = searchBar.text.utf16Count
//        self._loadDataForOffset("0", searchString: count > 0 ? searchBar.text : nil )
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar!){
//        searchBar.setShowsCancelButton(false, animated: false)
//        self.tableView.endEditing(true)
//        searchBar.text = ""
//        self.isSearching = false
//        self._updateDataSourceWith(self.heroes)
//    }
    
    
}

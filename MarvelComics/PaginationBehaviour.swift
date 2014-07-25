//
//  PaginationBehaviour.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 7/24/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

class PaginationBehaviour: NSObject {
    
    weak var arrayDataSource:ArrayDataSource?
    weak var tableView:UITableView? = nil;
    
    var isRequested:Bool = false;
    
    init(tableView:UITableView!, arrayDataSource:ArrayDataSource!){
        
        self.arrayDataSource = arrayDataSource
        self.tableView = tableView
        
        super.init()
    }
    
    //public
    
    func performPaginationIfShouldFor(velocity:CGPoint){
        let dataSourceSize:NSInteger = self.arrayDataSource!.items.count;
        let seenCellsCount:NSInteger = self._numberOfSeenCells()
        
        if ( !self.isRequested && velocity.y > 0 && (dataSourceSize - seenCellsCount) <= kHeroListDefaultServerLimite){
            self._loadDataFromServer()
        }
        
    }
    
    //private
    func _numberOfSeenCells() -> NSInteger {
        
        var numberOfSeenCells:NSInteger = 0
        let indexPathes:AnyObject[]! = self.tableView?.indexPathsForVisibleRows();
        let lastIndexPath:NSIndexPath? = indexPathes.isEmpty ? nil : indexPathes![indexPathes.count - 1] as? NSIndexPath
        
        
        if lastIndexPath {
            numberOfSeenCells = lastIndexPath!.row + 1;
        } else {
            numberOfSeenCells = self.arrayDataSource!.items.count;
        }
        
        return numberOfSeenCells
    }
    
    func _loadDataFromServer(){
        let dataSourceSize:NSInteger = self.arrayDataSource!.items.count;
        let offset:String = String(dataSourceSize)
        
        self.isRequested = true
        
        Hero.getHeroesList(offset: offset, searchFragment: nil, callback: {(heroes: Hero[]?, error: NSError?) in
            self.isRequested = false
            if heroes {
                let previouseSize = self.arrayDataSource?.items.count
                self.arrayDataSource?.addItems(heroes!)
                
                var indexPaths:AnyObject[] = []
                
                for var index = 0; index < heroes?.count; ++index {
                    indexPaths.append(NSIndexPath(forRow: index + previouseSize!, inSection: 0))
                }
                
                self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.None)
            }
            
        })
    }
    
}

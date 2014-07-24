//
//  PaginationBehaviour.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 7/24/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

class PaginationBehaviour: NSObject {
    var arrayDataSource:ArrayDataSource? = nil
    var tableView:UITableView? = nil;
    
    init(tableView:UITableView!, arrayDataSource:ArrayDataSource!){
        super.init()
        
        self.arrayDataSource = arrayDataSource
        self.tableView = tableView
    }
    
    //public
    
    func performPaginationIfShould(){
        
    }
    
    //private
    func numberOfSeenCells() -> NSInteger {
        
        var numberOfSeenCells:NSInteger = 0
        let indexPathes:AnyObject[]? = self.tableView?.indexPathsForVisibleRows();
        let lastIndexPath:NSIndexPath? = indexPathes?.isEmpty ? nil : indexPathes![indexPathes!.count - 1] as? NSIndexPath
        
        
        if lastIndexPath {
            numberOfSeenCells = lastIndexPath!.row + 1;
        } else {
            numberOfSeenCells = self.arrayDataSource!.items!.count;
        }
        
        return numberOfSeenCells
    }
}

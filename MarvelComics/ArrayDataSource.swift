//
//  ArrayDataSource.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

class ArrayDataSource: NSObject, UITableViewDataSource {
    
    var items  : [AnyObject] = []
    var cellID : String = ""
    var configureCellBlock:(cell:UITableViewCell!, item:AnyObject!) -> Void
    
    init(cellID:String!, configureCellBlock:(cell:UITableViewCell!, item:AnyObject!) -> () ){
        
        self.cellID = cellID
        self.configureCellBlock = configureCellBlock
        
        super.init()
        
    }
    
    func itemAt(indexPath:NSIndexPath!) -> AnyObject?{
        return self.items[indexPath.row]
    }
    
    func addItems(items:[AnyObject]){
        self.items += items
    }
    
    //tableView DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell : AnyObject? = tableView.dequeueReusableCellWithIdentifier(self.cellID)
        var item : AnyObject? = self.itemAt(indexPath)
        self.configureCellBlock(cell: cell as UITableViewCell, item: item)
        
        return cell as UITableViewCell
    }
    
}

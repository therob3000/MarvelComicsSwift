//
//  ArrayDataSource.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/10/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

class ArrayDataSource: NSObject, UITableViewDataSource {
    
    var items  : AnyObject[]? = nil
    var cellID : String = ""
    var configureCellBlock:(cell:UITableViewCell!, item:AnyObject!) -> Void
    
    init(items:AnyObject[]!, cellID:String!, configureCellBlock:(cell:UITableViewCell!, item:AnyObject!) -> () ){
        
        self.cellID = cellID
        self.items  = items
        self.configureCellBlock = configureCellBlock
        
        super.init()
        
    }
    
    func itemAt(indexPath:NSIndexPath!) -> AnyObject?{
        return self.items?[indexPath.row]
    }
    
    //tableView DataSource
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if items {
            return items!.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell : AnyObject? = tableView.dequeueReusableCellWithIdentifier(self.cellID)
        var item : AnyObject? = self.itemAt(indexPath)
        self.configureCellBlock(cell: cell as UITableViewCell, item: item)
        
        return cell as UITableViewCell
    }
    
}

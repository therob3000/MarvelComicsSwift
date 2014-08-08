//
//  Hero+Server.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/9/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import Foundation

let kHeroListDefaultServerLimite = 50

extension Hero {
    
    class func getHeroesList(limit:String = "50", offset:String!,searchFragment:String?, callback:((heroes:[Hero]?,error:NSError?) -> ())?){
        
        var params:Dictionary<String,String> = [paramLimit:limit, paramOffset: offset];
        var herroes:[Hero]
        
        HTTPRequesManager.sharedManager().dataWith(urlString: "characters",
            params:searchFragment ?
                [
                    paramLimit     : limit,
                    paramOffset    : offset,
                    paramSearchByName : searchFragment!
                ]:
                [
                    paramLimit     : limit,
                    paramOffset    : offset,
                ],
            succes: {(operation:AFHTTPRequestOperation!,responsObj:AnyObject!) in
                
                var responsDict : NSDictionary = responsObj as NSDictionary
                var heroesDicts: [NSDictionary]? = responsDict.valueForKeyPath("data.results") as? [NSDictionary];
 
                var heroes:[AnyObject]? = heroesDicts?.map(self.MR_importFromObject)
                
                callback?(heroes:heroes as? [Hero],error:nil)
                
            },
            failure:{(operation:AFHTTPRequestOperation!,error:NSError!) in
                if callback {
                    callback!(heroes:nil,error:error)
                }
            })
    }
}
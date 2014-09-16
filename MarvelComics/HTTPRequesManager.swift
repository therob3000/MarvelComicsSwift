//
//  HTTPRequesManager.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/8/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

let MARVEL_PUBLIC_API_KEY  = "be23153c199affa766dc9fe6f34fd524"
let MARVEL_PRIVATE_API_KEY = "9597bcd0e2339d5874d9913140b581ed0b55a921"
let paramApiKey            = "apikey"
let paramTimeStamp         = "ts"
let paramHash              = "hash"
let paramLimit             = "limit"
let paramOffset            = "offset"
let paramSearchByName      = "nameStartsWith"


import UIKit

enum HTTPRequesManagerHTTPMethodType{
    case GET
    
    case HEAD
    
    case POST
    
    case PUT
    
    case PATCH
    
    case DELETE
}

var instance: HTTPRequesManager? = nil
var onceToken: dispatch_once_t = 0

class HTTPRequesManager: AFHTTPRequestOperationManager {
    var dateFormater:NSDateFormatter?
    
    class func sharedManager() -> HTTPRequesManager{
        
        dispatch_once(&onceToken,{
            instance = HTTPRequesManager(baseURL: NSURL(string: "http://gateway.marvel.com/v1/public"))
            instance!.dateFormater = NSDateFormatter()
        })

        return instance!
    }

    func dataWith(methodeType:HTTPRequesManagerHTTPMethodType = .GET, urlString:String!, var params:Dictionary<String,String>?, succes:((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)?){
        
        var formatter:NSDateFormatter  = self.dateFormater!;
        formatter.dateFormat = "yyyyMMddHHmmss"
        var timeStampString:String = formatter.stringFromDate(NSDate.date())//[formatter stringFromDate:[NSDate date]];
        var hashString:String = NSString(string: "\(timeStampString)\(MARVEL_PRIVATE_API_KEY)\(MARVEL_PUBLIC_API_KEY)").MD5String()
        
        var newParams:Dictionary<String, String>
        
        if (params != nil) {
            newParams = params!
            newParams[paramApiKey] = MARVEL_PUBLIC_API_KEY
            newParams[paramHash] = hashString
            newParams[paramTimeStamp] = timeStampString
        }else{
            newParams = [paramApiKey:MARVEL_PUBLIC_API_KEY,
                paramHash : hashString,
                paramTimeStamp : timeStampString
                        ]
        }
        
        switch(methodeType){
            
        case .GET:
            self.GET(urlString, parameters: newParams, success: succes, failure: failure)
        
        case .POST:
            self.POST(urlString, parameters: newParams, success: succes, failure: failure)
            
        case .DELETE:
            self.DELETE(urlString, parameters: newParams, success: succes, failure: failure)
            
        case .PATCH:
            self.PATCH(urlString, parameters: newParams, success: succes, failure: failure)
            
        case .PUT:
            self.PUT(urlString, parameters: newParams, success: succes, failure: failure)
            
        default:
            self.GET(urlString, parameters: newParams, success: succes, failure: failure)
            
        }
        
    }
 }
 
//
//  Thumbnail.h
//  MarvelComics
//
//  Created by Sergey Shulga on 6/11/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Thumbnail : NSManagedObject

@property (nonatomic, retain) NSString * imageExtension;
@property (nonatomic, retain) NSString * path;

@end

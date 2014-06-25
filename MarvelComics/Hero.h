//
//  Hero.h
//  MarvelComics
//
//  Created by Sergey Shulga on 6/11/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Thumbnail;

@interface Hero : NSManagedObject

@property (nonatomic, retain) NSString * heroDescription;
@property (nonatomic, retain) NSNumber * heroId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Thumbnail *thumbnail;

@end

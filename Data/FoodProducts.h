//
//  FoodProducts.h
//  DogFood
//
//  Created by  on 29/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FoodProducts : NSManagedObject

@property (nonatomic, retain) NSString * dogAge;
@property (nonatomic, retain) NSString * foodBrand;
@property (nonatomic, retain) NSString * dogSize;
@property (nonatomic, retain) NSString * foodName;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * selectOne;
@property (nonatomic, retain) NSString * foodDescription;
@property (nonatomic, retain) NSString * webPage;

@end

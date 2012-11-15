//
//  GMMyDogFoodTableViewController.h
//  DogFood
//
//  Created by  on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "FoodProducts.h"
#import "GMDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GMMyDogFoodTableViewController : CoreDataTableViewController  <UIAlertViewDelegate>

@property (strong, nonatomic) NSString *dogAge;
@property (strong, nonatomic) NSString *dogSize;
@property (strong, nonatomic) NSString *foodBrand;
@property (strong, nonatomic) NSString *healthCare;
@property (strong, nonatomic) NSString *medicine;
@property (strong, nonatomic) NSString *dogBreed;
@property (strong, nonatomic) NSString *selectOne;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSArray *objects;  //The objects found in the database

@property (strong, nonatomic) NSString *queryingDogAge1;
@property (strong, nonatomic) NSString *queryingDogSize1;
@property (strong, nonatomic) NSString *queryingFoodBrand1;
@property (strong, nonatomic) NSString *queryingSelectOne1;

@property (strong, nonatomic) NSString *queryingDogAge2;
@property (strong, nonatomic) NSString *queryingDogSize2;
@property (strong, nonatomic) NSString *queryingFoodBrand2;
@property (strong, nonatomic) NSString *queryingSelectOne2;

@property (strong, nonatomic) FoodProducts *foodProductsSegue;

@end

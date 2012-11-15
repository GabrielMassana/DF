//
//  GMDogAgeTableViewController.h
//  DogFood
//
//  Created by  on 03/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FoodProducts.h"
#import "GMDetailViewController.h"

@class GMDogAgeTableViewController;

@protocol GMDogAgeTableViewControllerDelegate <NSObject>

- (void) gMDogAgeTableViewController: (GMDogAgeTableViewController *)controller didSelectdogAge:(NSString *)theDogAge;

@end

@interface GMDogAgeTableViewController : UITableViewController

@property (nonatomic, weak) id <GMDogAgeTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *dogAge;
@property (nonatomic, strong) NSDictionary *firstLevel;

@end

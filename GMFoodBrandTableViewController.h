//
//  GMFoodBrandTableViewController.h
//  DogFood
//
//  Created by  on 03/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMFoodBrandTableViewController;

@protocol GMFoodBrandTableViewControllerDelegate <NSObject>

- (void) gMFoodBrandTableViewController: (GMFoodBrandTableViewController *)controller didSelectFoodBrand:(NSString *)theFoodBrand;

@end

@interface GMFoodBrandTableViewController : UITableViewController

@property (nonatomic, weak) id <GMFoodBrandTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *foodBrand;
@property (nonatomic, strong) NSDictionary *firstLevel;

@end

//
//  GMHealthCareTableViewController.h
//  DogFood
//
//  Created by  on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMHealthCareTableViewController;

@protocol GMHealthCareTableViewControllerDelegate <NSObject>

- (void) gMHealthCareTableViewController: (GMHealthCareTableViewController *)controller didSelectHealthCare:(NSString *)theHealthCare;

@end

@interface GMHealthCareTableViewController : UITableViewController

@property (nonatomic, weak) id <GMHealthCareTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *healthCare;

@property (strong, nonatomic) IBOutlet UILabel *labelSelectOne;

@property (nonatomic, strong) NSDictionary *firstLevel;

@property (nonatomic) BOOL healthCarePressed;
@property (nonatomic) BOOL medicinePressed;
@property (nonatomic) BOOL breedPressed;

@property (strong, nonatomic) NSString *selectOne;

@end

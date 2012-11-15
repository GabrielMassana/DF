//
//  GMDogSizeTableViewController.h
//  DogFood
//
//  Created by  on 03/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMDogSizeTableViewController;

@protocol GMDogSizeTableViewControllerDelegate <NSObject>

- (void) gMDogSizeTableViewController: (GMDogSizeTableViewController *)controller didSelectDogSize:(NSString *)theDogSize;

@end

@interface GMDogSizeTableViewController : UITableViewController

@property (nonatomic, weak) id <GMDogSizeTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *dogSize;
@property (nonatomic, strong) NSDictionary *firstLevel;

@end

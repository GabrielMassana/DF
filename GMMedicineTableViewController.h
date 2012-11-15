//
//  GMMedicineTableViewController.h
//  DogFood
//
//  Created by  on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMMedicineTableViewController;

@protocol GMMedicineTableViewControllerDelegate <NSObject>

- (void) gMMedicineTableViewController: (GMMedicineTableViewController *)controller didSelectMedicine:(NSString *)theMedicine;

@end

@interface GMMedicineTableViewController : UITableViewController

@property (nonatomic, weak) id <GMMedicineTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *medicine;

@property (strong, nonatomic) IBOutlet UILabel *labelSelectOne;

@property (nonatomic, strong) NSDictionary *firstLevel;

@property (nonatomic) BOOL healthCarePressed;
@property (nonatomic) BOOL medicinePressed;
@property (nonatomic) BOOL breedPressed;

@property (strong, nonatomic) NSString *selectOne;

@end
//
//  GMDogBreedTableViewController.h
//  DogFood
//
//  Created by  on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMDogBreedTableViewController;

@protocol GMDogBreedTableViewControllerDelegate <NSObject>

- (void) gMDogBreedTableViewController: (GMDogBreedTableViewController *)controller didSelectDogBreed:(NSString *)theDogBreed;

@end

@interface GMDogBreedTableViewController : UITableViewController

@property (nonatomic, weak) id <GMDogBreedTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *dogBreed;

@property (strong, nonatomic) IBOutlet UILabel *labelSelectOne;

@property (nonatomic, strong) NSDictionary *firstLevel;

@property (nonatomic) BOOL healthCarePressed;
@property (nonatomic) BOOL medicinePressed;
@property (nonatomic) BOOL breedPressed;

@property (strong, nonatomic) NSString *selectOne;

@end

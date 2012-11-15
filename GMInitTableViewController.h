//
//  GMInitTableViewController.h
//  DogFood
//
//  Created by  on 01/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMDogAgeTableViewController.h"
#import "GMDogSizeTableViewController.h"
#import "GMFoodBrandTableViewController.h"
#import "GMHealthCareTableViewController.h"
#import "GMMedicineTableViewController.h"
#import "GMDogBreedTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GMInitTableViewController : UIViewController <GMDogAgeTableViewControllerDelegate, GMDogSizeTableViewControllerDelegate, GMFoodBrandTableViewControllerDelegate, GMHealthCareTableViewControllerDelegate, GMMedicineTableViewControllerDelegate, GMDogBreedTableViewControllerDelegate>
{
    CGAffineTransform translateAge;
    CGAffineTransform translateSize;
    CGAffineTransform translateBrand;
    CGAffineTransform translateHealthCare;
    CGAffineTransform translateMedicine;
    CGAffineTransform translateBreed;
}

@property (strong, nonatomic) NSString *dogAge;
@property (strong, nonatomic) NSString *dogSize;
@property (strong, nonatomic) NSString *foodBrand;
@property (strong, nonatomic) NSString *healthCare;
@property (strong, nonatomic) NSString *medicine;
@property (strong, nonatomic) NSString *dogBreed;
@property (strong, nonatomic) NSString *selectOne;

@property (strong, nonatomic) IBOutlet UIButton *buttonAge;
@property (strong, nonatomic) IBOutlet UIButton *buttonSize;
@property (strong, nonatomic) IBOutlet UIButton *buttonBrand;
@property (strong, nonatomic) IBOutlet UIButton *buttonHealthCare;
@property (strong, nonatomic) IBOutlet UIButton *buttonMedicine;
@property (strong, nonatomic) IBOutlet UIButton *buttonBreed;
@property (strong, nonatomic) IBOutlet UIButton *buttonGo;
@property (strong, nonatomic) IBOutlet UIButton *buttonSelectOne;

@property (strong, nonatomic) IBOutlet UILabel *labelAge;
@property (strong, nonatomic) IBOutlet UILabel *labelSize;
@property (strong, nonatomic) IBOutlet UILabel *labelBrand;
@property (strong, nonatomic) IBOutlet UILabel *labelSelectOne;


@property (strong, nonatomic) IBOutlet UILabel *labelInfoHealthCare;
@property (strong, nonatomic) IBOutlet UILabel *labelInfoMedicine;
@property (strong, nonatomic) IBOutlet UILabel *labelInfoBreed;
@property (strong, nonatomic) IBOutlet UILabel *labelInfoAge;
@property (strong, nonatomic) IBOutlet UILabel *labelInfoSize;
@property (strong, nonatomic) IBOutlet UILabel *labelInfoBrand;

@property (strong, nonatomic) IBOutlet UILabel *labelViewSelectOne;

@property (nonatomic) BOOL healthCarePressed;
@property (nonatomic) BOOL medicinePressed;
@property (nonatomic) BOOL breedPressed;

@property (strong, nonatomic) IBOutlet UIImageView *imageAge;
@property (strong, nonatomic) IBOutlet UIImageView *imageHealthCare;
@property (strong, nonatomic) IBOutlet UIImageView *imageSize;
@property (strong, nonatomic) IBOutlet UIImageView *imageBrand;
@property (strong, nonatomic) IBOutlet UIImageView *imageMedicine;
@property (strong, nonatomic) IBOutlet UIImageView *imageBreed;


- (IBAction)resetButtonPressed:(id)sender;

@end

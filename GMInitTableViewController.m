//
//  GMInitTableViewController.m
//  DogFood
//
//  Created by  on 01/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GMInitTableViewController.h"

@interface GMInitTableViewController ()
@end

@implementation GMInitTableViewController

@synthesize imageAge;
@synthesize imageHealthCare;
@synthesize imageSize;
@synthesize imageBrand;
@synthesize imageMedicine;
@synthesize imageBreed;

@synthesize dogAge, foodBrand, dogSize, healthCare, dogBreed, medicine, selectOne;

@synthesize buttonAge;
@synthesize buttonSize;
@synthesize buttonBrand;
@synthesize buttonHealthCare;
@synthesize buttonMedicine;
@synthesize buttonBreed;
@synthesize buttonGo;
@synthesize buttonSelectOne;
@synthesize labelAge;
@synthesize labelSize;
@synthesize labelBrand;
@synthesize labelSelectOne;
@synthesize labelInfoHealthCare;
@synthesize labelInfoMedicine;
@synthesize labelInfoBreed;
@synthesize labelViewSelectOne;

@synthesize healthCarePressed, medicinePressed, breedPressed;


- (void)viewDidLoad
{
    [super viewDidLoad];        
    
    healthCarePressed = NO;
    medicinePressed = NO;
    breedPressed = NO;
    
    [self customNavigationBar];
    
    [self hardcodingLayoutIPhoneFive];
    
    [self buttonsImageBackground];
    
    [self animatedImagesLaunchingApp];    
}

- (void)viewDidUnload
{

    [self setButtonAge:nil];
    [self setButtonSize:nil];
    [self setButtonBrand:nil];
    [self setButtonHealthCare:nil];
    [self setButtonMedicine:nil];
    [self setButtonBreed:nil];
    [self setButtonGo:nil];
    [self setLabelAge:nil];
    [self setLabelSize:nil];
    [self setLabelBrand:nil];
    [self setLabelSelectOne:nil];
    [self setLabelInfoHealthCare:nil];
    [self setLabelInfoMedicine:nil];
    [self setLabelInfoBreed:nil];
    [self setLabelViewSelectOne:nil];
    [self setButtonSelectOne:nil];
    [self setImageAge:nil];
    [self setImageHealthCare:nil];
    [self setImageSize:nil];
    [self setImageBrand:nil];
    [self setImageMedicine:nil];
    [self setImageBreed:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - GMDogAgeTableViewController

- (void) gMDogAgeTableViewController: (GMDogAgeTableViewController *)controller didSelectdogAge:(NSString *)theDogAge;
{
	dogAge = theDogAge;
    
    // return data from delegation
    // reset label in Button Go if the user has selected 'None'
    if ([dogAge isEqualToString:@"None"])
    {
        self.labelAge.text = @"Age";
        self.labelAge.textColor = [UIColor blackColor];
    }
    else
    {
        self.labelAge.text = dogAge;
        self.labelAge.textColor = [UIColor colorWithRed:(float)0xff/0xff
                                                  green:(float)0x26/0xff
                                                   blue:(float)0x00/0xff
                                                  alpha:1.0];
    }
    
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - GMDogSizeTableViewController

- (void) gMDogSizeTableViewController: (GMDogSizeTableViewController *)controller didSelectDogSize:(NSString *)theDogSize;
{
	dogSize = theDogSize;
    
    // return data from delegation
    // reset label in Button Go if the user has selected 'None'
    if ([dogSize isEqualToString:@"None"])
    {
        self.labelSize.text = @"Size";
        self.labelSize.textColor = [UIColor blackColor];
    }
    else
    {     
        self.labelSize.text = dogSize;
        self.labelSize.textColor = [UIColor colorWithRed:(float)0xff/0xff
                                                   green:(float)0x93/0xff
                                                    blue:(float)0x00/0xff
                                                   alpha:1.0];
    }
    
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - GMFoodBrandTableViewController


- (void) gMFoodBrandTableViewController: (GMFoodBrandTableViewController *)controller didSelectFoodBrand:(NSString *)theFoodBrand;
{
	foodBrand = theFoodBrand;
    
    // return data from delegation
    // reset label in Button Go if the user has selected 'None'
    if ([foodBrand isEqualToString:@"None"])
    {
        self.labelBrand.text = @"Brand";
        self.labelBrand.textColor = [UIColor blackColor];
    }
    else
    {
    	self.labelBrand.text = foodBrand;
        self.labelBrand.textColor = [UIColor colorWithRed:(float)0x00/0xff
                                                    green:(float)0x8e/0xff
                                                     blue:(float)0x00/0xff
                                                    alpha:1.0];
    }
    
	[self.navigationController popViewControllerAnimated:YES];   
}

#pragma mark - GMHealthCareTableViewController

- (void) gMHealthCareTableViewController: (GMHealthCareTableViewController *)controller didSelectHealthCare:(NSString *)theHealthCare;
{
	healthCare = theHealthCare;
    
    // return data from delegation
    // reset label in Button Go if the user has selected 'None'
    if ([healthCare isEqualToString:@"None"])
    {
        self.labelSelectOne.text = @"Select One";
        self.labelSelectOne.textColor = [UIColor blackColor];
    }
    else
    {
        self.labelSelectOne.text = healthCare;
        self.labelSelectOne.textColor = [UIColor colorWithRed:(float)0x04/0xff
                                                        green:(float)0x32/0xff
                                                         blue:(float)0xff/0xff
                                                        alpha:1.0];
    }
    
	[self.navigationController popViewControllerAnimated:YES];
    
    // if the user has selected something from Health Care list/view: BOOL healthCarePressed  = YES  
    if (![healthCare isEqualToString:@"None"])
    {        
        healthCarePressed = YES;
        medicinePressed = NO;
        breedPressed = NO;
    }
    else
    {        
        healthCarePressed = NO;
        medicinePressed = NO;
        breedPressed = NO;
    }
    
}

#pragma mark - GMMedicineTableViewController

- (void) gMMedicineTableViewController: (GMMedicineTableViewController *)controller didSelectMedicine:(NSString *)theMedicine;
{
	medicine = theMedicine;
    
    // return data from delegation
    // reset label in Button Go if the user has selected 'None'
	if ([medicine isEqualToString:@"None"])
    {
        self.labelSelectOne.text = @"Select One";
        self.labelSelectOne.textColor = [UIColor blackColor];
    }
    else
    {
        self.labelSelectOne.text = medicine;
        self.labelSelectOne.textColor = [UIColor colorWithRed:(float)0x04/0xff
                                                        green:(float)0x32/0xff
                                                         blue:(float)0xff/0xff
                                                        alpha:1.0];
	}
    
    [self.navigationController popViewControllerAnimated:YES];
    
    // if the user has selected something from Medicine list/view: BOOL medicinePressed  = YES
    if (![medicine isEqualToString:@"None"])
    {
        healthCarePressed = NO;
        medicinePressed = YES;
        breedPressed = NO;        
    }
    else 
    {
        healthCarePressed = NO;
        medicinePressed = NO;
        breedPressed = NO;
    }
}

#pragma mark - GMDogBreedTableViewController

- (void) gMDogBreedTableViewController: (GMDogBreedTableViewController *)controller didSelectDogBreed:(NSString *)theDogBreed;
{
	dogBreed = theDogBreed;
	
    // return data from delegation
    // reset label in Button Go if the user has selected 'None'
    if ([dogBreed isEqualToString:@"None"])
    {
        self.labelSelectOne.text = @"Select One";
        self.labelSelectOne.textColor = [UIColor blackColor];
    }
    else
    {
        self.labelSelectOne.text = dogBreed;
        self.labelSelectOne.textColor = [UIColor colorWithRed:(float)0x04/0xff
                                                        green:(float)0x32/0xff
                                                         blue:(float)0xff/0xff
                                                        alpha:1.0];
    }
	[self.navigationController popViewControllerAnimated:YES];

    // if the user has selected something from Breed list/view: BOOL breedPressed  = YES
    if (![dogBreed isEqualToString:@"None"])
    {        
        healthCarePressed = NO;
        medicinePressed = NO;
        breedPressed = YES;        
    }
    else
    {
        healthCarePressed = NO;
        medicinePressed = NO;
        breedPressed = NO;
    }
}


# pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"DogAge"])
	{
		GMDogAgeTableViewController *gMDogAgeTableViewController = segue.destinationViewController;
		gMDogAgeTableViewController.delegate = self;
		gMDogAgeTableViewController.dogAge = dogAge;
        
        [segue.destinationViewController setDogAge:labelAge.text];
        
        
	}
    else if ([segue.identifier isEqualToString:@"DogSize"])
	{
		GMDogSizeTableViewController *gMDogSizeTableViewController = segue.destinationViewController;
		gMDogSizeTableViewController.delegate = self;
		gMDogSizeTableViewController.dogSize = dogSize;
        
        [segue.destinationViewController setDogSize:labelSize.text];
        
        
	}
    else if ([segue.identifier isEqualToString:@"FoodBrand"])
	{
		GMFoodBrandTableViewController *gMFoodBrandeTableViewController = segue.destinationViewController;
		gMFoodBrandeTableViewController.delegate = self;
		gMFoodBrandeTableViewController.foodBrand = foodBrand;
        
        [segue.destinationViewController setFoodBrand:labelBrand.text];
        
	}
    else if ([segue.identifier isEqualToString:@"HealthCare"])
	{
		GMHealthCareTableViewController *gMHealthCareTableViewController = segue.destinationViewController;
		gMHealthCareTableViewController.delegate = self;
		gMHealthCareTableViewController.healthCare = healthCare;
        
        [segue.destinationViewController setLabelSelectOne:labelSelectOne];
        [segue.destinationViewController setBreedPressed:breedPressed];
        [segue.destinationViewController setMedicinePressed:medicinePressed];
        [segue.destinationViewController setSelectOne:labelSelectOne.text];
        
	}
    else if ([segue.identifier isEqualToString:@"Medicine"])
	{
		GMMedicineTableViewController *gMMedicineTableViewController = segue.destinationViewController;
		gMMedicineTableViewController.delegate = self;
		gMMedicineTableViewController.medicine = medicine;
        
        [segue.destinationViewController setLabelSelectOne:labelSelectOne];
        [segue.destinationViewController setBreedPressed:breedPressed];
        [segue.destinationViewController setHealthCarePressed:healthCarePressed];
        [segue.destinationViewController setSelectOne:labelSelectOne.text];
        
	}
    else if ([segue.identifier isEqualToString:@"DogBreed"])
	{
		GMDogBreedTableViewController *gMDogBreedTableViewController = segue.destinationViewController;
		gMDogBreedTableViewController.delegate = self;
		gMDogBreedTableViewController.dogBreed = dogBreed;
        
        [segue.destinationViewController setLabelSelectOne:labelSelectOne];
        [segue.destinationViewController setMedicinePressed:medicinePressed];
        [segue.destinationViewController setHealthCarePressed:healthCarePressed];
        [segue.destinationViewController setSelectOne:labelSelectOne.text];
        
	}
    else if ([segue.identifier isEqualToString:@"MyDogFoods"])
	{
		[segue.destinationViewController setDogAge:self.labelAge.text];
		[segue.destinationViewController setDogSize:self.labelSize.text];
		[segue.destinationViewController setFoodBrand:self.labelBrand.text];
        [segue.destinationViewController setSelectOne:self.labelSelectOne.text];
	}   
    
}

#pragma mark - Reset Button Pressed

- (IBAction)resetButtonPressed:(id)sender
{
    self.labelSelectOne.text = @"Select One";
    self.labelSelectOne.textColor = [UIColor blackColor];
    
    self.labelAge.text = @"Age";
    self.labelAge.textColor = [UIColor blackColor];
    
    
    self.labelSize.text = @"Size";
    self.labelSize.textColor = [UIColor blackColor];
    
    self.labelBrand.text = @"Brand";
    self.labelBrand.textColor = [UIColor blackColor];     
}

# pragma mark - stuff - custom navigation bar

- (void) customNavigationBar
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 120, 24)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Didot-Bold" size:24.0];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor whiteColor];
    label.text=@".DogFood";
    self.navigationItem.titleView = label;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
}


# pragma mark - stuff - view buttons image background

- (void) buttonsImageBackground
{
    UIImage *backgroundButton5 = [[UIImage imageNamed:@"fonsButtonFive.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];    
    
    [buttonSelectOne setBackgroundImage:backgroundButton5 forState:UIControlStateNormal];
    [buttonSelectOne setBackgroundImage:backgroundButton5 forState:UIControlStateDisabled];
    
    
    [buttonAge setBackgroundImage:backgroundButton5 forState:UIControlStateNormal];
    [buttonSize setBackgroundImage:backgroundButton5 forState:UIControlStateNormal];
    [buttonBrand setBackgroundImage:backgroundButton5 forState:UIControlStateNormal];
    
    [buttonHealthCare setBackgroundImage:backgroundButton5 forState:UIControlStateNormal];
    [buttonMedicine setBackgroundImage:backgroundButton5 forState:UIControlStateNormal];
    [buttonBreed setBackgroundImage:backgroundButton5 forState:UIControlStateNormal];
    
    [buttonGo setBackgroundImage:backgroundButton5 forState:UIControlStateNormal];
}


# pragma mark - other stuff - hardcoding (not auto) layout for iPhone 5

- (void) hardcodingLayoutIPhoneFive
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            CGFloat scale = [UIScreen mainScreen].scale;
            result = CGSizeMake(result.width * scale, result.height * scale);
            
            if(result.height == 960) {
                NSLog(@"iPhone 4 Resolution");
            }
            if(result.height == 1136) {
                NSLog(@"iPhone 5 Resolution");
                
                
                CGRect rect = self.buttonAge.frame;
                rect.origin.y = 32;
                rect.size.width = 159;
                rect.size.height = 129;
                self.buttonAge.frame = rect;
                
                rect = self.buttonSize.frame;
                rect.origin.y = 178;
                rect.size.width = 159;
                rect.size.height = 130;
                self.buttonSize.frame = rect;
                
                rect = self.buttonBrand.frame;
                rect.origin.y = 324;
                rect.size.width = 159;
                rect.size.height = 130;
                self.buttonBrand.frame = rect;
                
                rect = self.buttonHealthCare.frame;
                rect.origin.y = 32;
                rect.size.width = 160;
                rect.size.height = 129;
                self.buttonHealthCare.frame = rect;
                
                rect = self.buttonMedicine.frame;
                rect.origin.y = 178;
                rect.size.width = 160;
                rect.size.height = 130;
                self.buttonMedicine.frame = rect;
                
                rect = self.buttonBreed.frame;
                rect.origin.y = 324;
                rect.size.width = 160;
                rect.size.height = 130;
                self.buttonBreed.frame = rect;
                
                                
                rect = self.buttonGo.frame;
                rect.origin.y = 465;
                self.buttonGo.frame = rect;
                
                
                rect = self.labelInfoAge.frame;
                rect.origin.x = 65;
                rect.origin.y = 140;
                rect.size.width = 30;
                rect.size.height = 20;
                self.labelInfoAge.frame = rect;
                
                rect = self.labelInfoSize.frame;
                rect.origin.x = 65;
                rect.origin.y = 283;
                rect.size.width = 30;
                rect.size.height = 20;
                self.labelInfoSize.frame = rect;
                
                rect = self.labelInfoBrand.frame;
                rect.origin.x = 59;
                rect.origin.y = 426;
                rect.size.width = 42;
                rect.size.height = 20;
                self.labelInfoBrand.frame = rect;
                                
                
                rect = self.labelInfoHealthCare.frame;
                rect.origin.x = 199;
                rect.origin.y = 140;
                rect.size.width = 82;
                rect.size.height = 20;
                self.labelInfoHealthCare.frame = rect;
                
                rect = self.labelInfoMedicine.frame;
                rect.origin.x = 208;
                rect.origin.y = 283;
                rect.size.width = 64;
                rect.size.height = 20;
                self.labelInfoMedicine.frame = rect;
                
                rect = self.labelInfoBreed.frame;
                rect.origin.x = 219;
                rect.origin.y = 426;
                rect.size.width = 42;
                rect.size.height = 20;
                self.labelInfoBreed.frame = rect;
                
                
                rect = self.labelAge.frame;
                rect.origin.x = 12;
                rect.origin.y = 469;
                rect.size.width = 201;
                rect.size.height = 20;
                self.labelAge.frame = rect;
                
                rect = self.labelSize.frame;
                rect.origin.x = 12;
                rect.origin.y = 486;
                rect.size.width = 201;
                rect.size.height = 20;
                self.labelSize.frame = rect;
                
                rect = self.labelBrand.frame;
                rect.origin.x = 12;
                rect.origin.y = 502;
                rect.size.width = 201;
                rect.size.height = 20;
                self.labelBrand.frame = rect;
                                
                rect = self.labelSelectOne.frame;
                rect.origin.x = 12;
                rect.origin.y = 519;
                rect.size.width = 201;
                rect.size.height = 20;
                self.labelSelectOne.frame = rect;
                
                                 
                rect = self.imageAge.frame;
                rect.origin.y = 62;
                self.imageAge.frame = rect;
                
                rect = self.imageSize.frame;
                rect.origin.y = 208;
                self.imageSize.frame = rect;
                
                rect = self.imageBrand.frame;
                rect.origin.y = 354;
                self.imageBrand.frame = rect;
                
                rect = self.imageHealthCare.frame;
                rect.origin.y = 62;
                self.imageHealthCare.frame = rect;
                
                rect = self.imageMedicine.frame;
                rect.origin.y = 208;
                self.imageMedicine.frame = rect;
                
                rect = self.imageBreed.frame;
                rect.origin.y = 354;
                self.imageBreed.frame = rect;
                
            }
        }
        else{
            NSLog(@"Standard Resolution");
        }
    }    
}


# pragma mark - other stuff - move images

- (void) animatedImagesLaunchingApp
{      
    translateAge = CGAffineTransformMakeTranslation(189, 0);
    translateSize = CGAffineTransformMakeTranslation(189, 0);
    translateBrand = CGAffineTransformMakeTranslation(189, 0);
    translateHealthCare = CGAffineTransformMakeTranslation(-185, 0);
    translateMedicine = CGAffineTransformMakeTranslation(-185, 0);
    translateBreed = CGAffineTransformMakeTranslation(-185, 0);
    
    // Left    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.65];
    imageAge.transform = translateAge;
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.9];
    imageSize.transform = translateSize;
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.2];
    imageBrand.transform = translateBrand;
    [UIView commitAnimations];
    
    //Right
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.65];
    imageHealthCare.transform = translateHealthCare;
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.9];
    imageMedicine.transform = translateMedicine;
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.2];
    imageBreed.transform = translateBreed;
    [UIView commitAnimations];
}

@end

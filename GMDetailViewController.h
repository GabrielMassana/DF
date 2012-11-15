//
//  GMDetailViewController.h
//  DogFood
//
//  Created by  on 22/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodProducts.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@interface GMDetailViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) FoodProducts *foodProductsSegue;

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *buttonFoodName;

- (IBAction)openWeb:(id)sender;
- (IBAction)sendEMailPressed:(id)sender;

@end

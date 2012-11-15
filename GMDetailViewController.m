//
//  GMDetailViewController.m
//  DogFood
//
//  Created by  on 22/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GMDetailViewController.h"

@interface GMDetailViewController ()

@end

@implementation GMDetailViewController

@synthesize foodProductsSegue;
@synthesize textView;
@synthesize buttonFoodName;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customButtonNameFood];
    [self customNavigationBar];
    [self customTextViewFoodDetail];    
    
    [self hardcodingLayoutIPhoneFive];    
    
    // Add text to TextView
    NSString *textViewTextString = [[NSString alloc] initWithFormat:@"%@ ",  foodProductsSegue.foodDescription];    
    [self.textView setText:textViewTextString];    
    
    // Add text to Button
    [self.buttonFoodName setTitle:foodProductsSegue.foodName forState:UIControlStateNormal];    
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [self setButtonFoodName:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)openWeb:(id)sender
{
    NSURL *url = [NSURL URLWithString:foodProductsSegue.webPage];
    
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Opppsss. Error obrint la url:",[url description]);
}

#pragma mark - Send (E-Mail) pressed


- (IBAction)sendEMailPressed:(id)sender
{
    [self sendEmailAction];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSLog(@"Message Sent or Cancelled or Saved");
	[self dismissViewControllerAnimated:YES completion:nil];	
}

- (void) sendEmailAction
{
    
    if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
		mfViewController.mailComposeDelegate = self;
        
        NSString *subject = [[NSString alloc] initWithFormat:@".DogFood - %@",  foodProductsSegue.foodName];        
        [mfViewController setSubject:subject];
        
        NSString *body = [[NSString alloc] initWithFormat:@"%@ \r\n \r\n %@ \r\n \r\n %@ \r\n \r\n %@",  foodProductsSegue.foodName, foodProductsSegue.foodBrand ,foodProductsSegue.foodDescription, foodProductsSegue.webPage];
        
        [mfViewController setMessageBody:body isHTML:NO];        
		[self presentViewController:mfViewController animated:YES completion:nil];
	}
    else
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"Your phone is not currently configured to send mail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alert show];
	}
}

# pragma mark - stuff - custom navigation bar

- (void) customNavigationBar
{
    // Custom NavBar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 220, 24)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Didot-Bold" size:19.0];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor whiteColor];
    label.text=@".DogFood Detail";
    self.navigationItem.titleView = label;
}


# pragma mark - stuff - custom button name food

- (void) customButtonNameFood
{
    // Custom Button
    [self.buttonFoodName.layer setCornerRadius:4.0f];
    [self.buttonFoodName.layer setMasksToBounds:NO];
    [self.buttonFoodName.layer setBorderWidth:0.7];
    self.buttonFoodName.layer.shadowOpacity = 1;
    
    self.buttonFoodName.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.buttonFoodName.layer.shadowRadius = 10;
    self.buttonFoodName.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
}

# pragma mark - stuff - custom text view food detail

- (void) customTextViewFoodDetail
{
    // Custom TextView
    self.textView.textColor = [UIColor whiteColor];
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
                
                CGRect rect = self.textView.frame;
                rect.origin.x = 20;
                rect.origin.y = 93;
                rect.size.height = 425;
                self.textView.frame = rect;                
            }
        }
        else
        {
            NSLog(@"Standard Resolution");
        }
    }
}

@end

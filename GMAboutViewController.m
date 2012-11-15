//
//  GMAboutViewController.m
//  DogFood
//
//  Created by  on 29/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GMAboutViewController.h"

@interface GMAboutViewController ()

@end

@implementation GMAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customNavigationBar];
    [self hardcodingLayoutIPhoneFive];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Email

- (IBAction)sendMail:(id)sender 
{
    if ([MFMailComposeViewController canSendMail]) 
    {
		MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
		mfViewController.mailComposeDelegate = self;
        [mfViewController setSubject:@".DogFood"];       
        
        [mfViewController setToRecipients:[NSArray arrayWithObjects:@"dogfood@gabrielmassana.com",nil]];
        
		[self presentViewController:mfViewController animated:YES  completion:nil];
	}
    else 
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"Your phone is not currently configured to send mail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];		
		[alert show];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
    NSLog(@"Message Sent or Cancelled or Saved");
	[self dismissViewControllerAnimated:YES completion:nil];
	
}


#pragma mark - Twitter

- (IBAction)sendTweet:(id)sender 
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        NSString *stringMissatgeTwitt = [NSString stringWithFormat:@".DogFood @DogFoodApp "];
        
        SLComposeViewController * twitt = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitt setInitialText:stringMissatgeTwitt];
        [self presentViewController:twitt animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Your Twitter account is not configured." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }   
}

#pragma mark - Facebook

//Working on it
- (IBAction)sendFacebook:(id)sender
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
       /*
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        */
        [controller setInitialText:@".DogFood is really useful!"];
        //[controller addImage:[UIImage imageNamed:@"dogFood57.png"]];
        [controller addURL:[NSURL URLWithString:@"http://dogfoodapp.wordpress.com/"]];

        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    else
    {
        NSLog(@"UnAvailable");
    }
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
    label.text=@"About";
    self.navigationItem.titleView = label;
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
                
                CGRect rect = self.buttonFacebook.frame;
                rect.origin.y = 321;
                self.buttonFacebook.frame = rect;
            }
        }
        else{
            NSLog(@"Standard Resolution");
        }
    }
}


@end

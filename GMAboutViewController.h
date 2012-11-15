//
//  GMAboutViewController.h
//  DogFood
//
//  Created by  on 29/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>

@interface GMAboutViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)sendMail:(id)sender;
- (IBAction)sendTweet:(id)sender;
- (IBAction)sendFacebook:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *buttonFacebook;

@end

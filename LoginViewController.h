//
//  LoginViewController.h
//  SPACES
//
//  Created by Michael Wang on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <UITextFieldDelegate> {
	UIScrollView *scrollView;
	UITextField *usernameField;
	UITextField *passwordField;
	UIToolbar *toolbar;
	UIBarButtonItem *signupButtonItem;
	UIBarButtonItem *loginButtonItem;
	
	NSString *username;
	NSString *password;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *signupButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *loginButtonItem;


- (IBAction)twitterSignup;
- (IBAction)twitterLogin;
- (IBAction)cancelLogin;


@end

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
	
	UIView *flashMessageView;
	UILabel *flashMessageLabel;
	UIActivityIndicatorView *loginActivityView;
	
	
	NSString *username;
	NSString *password;
	
	id successfulLoginObject;
	SEL successfulLoginSelector;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *signupButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *loginButtonItem;

@property (nonatomic, retain) IBOutlet UIView *flashMessageView;
@property (nonatomic, retain) IBOutlet UILabel *flashMessageLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loginActivityView;


- (IBAction)twitterSignup;
- (IBAction)twitterLogin;
- (IBAction)cancelLogin;

- (void)onSuccessfulLoginPerformSelector:(SEL)selector withObject:(id)anObject;


@end

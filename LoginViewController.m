//
//  LoginViewController.m
//  SPACES
//
//  Created by Michael Wang on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "SpacesTwitterConnection.h"
#import "PhotoPickerViewController.h"


@implementation LoginViewController

@synthesize scrollView;
@synthesize usernameField;
@synthesize passwordField;
@synthesize toolbar;
@synthesize signupButtonItem;
@synthesize loginButtonItem;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	
	// register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(liftMainViewWhenKeybordAppears:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(returnMainViewToInitialposition:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) liftMainViewWhenKeybordAppears:(NSNotification*)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    self.toolbar.frame = CGRectMake(self.toolbar.frame.origin.x, self.toolbar.frame.origin.y - keyboardFrame.size.height,
									self.toolbar.frame.size.width, self.toolbar.frame.size.height);
    [UIView commitAnimations];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) returnMainViewToInitialposition:(NSNotification*)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    self.toolbar.frame = CGRectMake(self.toolbar.frame.origin.x, self.toolbar.frame.origin.y + keyboardFrame.size.height,
									self.toolbar.frame.size.width, self.toolbar.frame.size.height);
    [UIView commitAnimations];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[username release];
	[password release];
    [super dealloc];
}






#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
    // the user pressed the "Done" button, so dismiss the keyboard
    [textField resignFirstResponder];
    return YES;
}






- (IBAction)twitterSignup {
	NSLog(@"SIGNUP");
}

- (IBAction)twitterLogin {
	
	NSLog(@"USER: %@", self.usernameField.text);
	NSLog(@"PASS: %@", self.passwordField.text);
	
	[username release];
	[password release];
	username = [self.usernameField.text retain];
	password = [self.passwordField.text retain];
	
	SpacesTwitterConnection *twitter = [[[SpacesTwitterConnection alloc] initWithDelegate:self] autorelease];
	[twitter setUsername:self.usernameField.text andPassword:self.passwordField.text];
	NSString *results = [twitter checkUserCredentials];
	
	NSLog(@"RESULT: %@", results);
	
}



#pragma mark -
#pragma mark Twitter_CALLBACK


- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
	NSLog(@"CONN ID: %@", connectionIdentifier);
	NSLog(@"USER INFO: %@", userInfo);
	
	NSDictionary *user = [userInfo objectAtIndex:0];
	
	if ([user objectForKey:@"id"] != nil) {
		[[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
		[[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
		
		[self dismissModalViewControllerAnimated:YES];
		
	}
	else {
		// cannot log in, popup?
	}
	
}




- (IBAction)cancelLogin {
	[self dismissModalViewControllerAnimated:YES];
}


@end

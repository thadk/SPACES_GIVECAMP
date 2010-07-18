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
#import "SignupViewController.h"


@implementation LoginViewController

@synthesize scrollView;
@synthesize usernameField;
@synthesize passwordField;
@synthesize toolbar;
@synthesize signupButtonItem;
@synthesize loginButtonItem;

@synthesize flashMessageView;
@synthesize flashMessageLabel;
@synthesize loginActivityView;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


- (void)onSuccessfulLoginPerformSelector:(SEL)selector withObject:(id)anObject {
	successfulLoginObject = [anObject retain];
	successfulLoginSelector = selector;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	toolbar.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	
	self.title = @"Twitter Sign In";
	
	
	self.flashMessageView.hidden = YES;
	
	// register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(liftMainViewWhenKeybordAppears:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(returnMainViewToInitialposition:) name:UIKeyboardWillHideNotification object:nil];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	

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
    self.toolbar.frame = CGRectMake(self.toolbar.frame.origin.x, self.view.frame.size.height - keyboardFrame.size.height - self.toolbar.frame.size.height,
									self.toolbar.frame.size.width, self.toolbar.frame.size.height);
    [UIView commitAnimations];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
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
    self.toolbar.frame = CGRectMake(self.toolbar.frame.origin.x, self.view.frame.size.height - self.toolbar.frame.size.height,
									self.toolbar.frame.size.width, self.toolbar.frame.size.height);
    [UIView commitAnimations];
}



- (void)viewDidDisappear:(BOOL)animated {
	self.flashMessageView.hidden = YES;
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
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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
	
	SignupViewController *signupController = [[SignupViewController alloc] init];
	[self.navigationController pushViewController:signupController animated:YES];
	[signupController release];
	
}

- (IBAction)twitterLogin {
	
	
	//self.flashMessageView.backgroundColor = [UIColor blackColor];
	self.flashMessageView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
	
	self.flashMessageLabel.textColor = [UIColor whiteColor];
	self.flashMessageLabel.text = @"Logging in...";
	self.loginActivityView.hidden = NO;
	[self.loginActivityView startAnimating];
	self.flashMessageView.hidden = NO;
	
	[username release];
	[password release];
	username = [self.usernameField.text retain];
	password = [self.passwordField.text retain];
	
	SpacesTwitterConnection *twitter = [[[SpacesTwitterConnection alloc] initWithDelegate:self] autorelease];
	[twitter setUsername:self.usernameField.text andPassword:self.passwordField.text];
	[twitter checkUserCredentials];
	
}



#pragma mark -
#pragma mark Twitter_CALLBACK


// response from twitter check credentials call
- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
	
	[self.loginActivityView stopAnimating];
	
	NSDictionary *user = [userInfo objectAtIndex:0];
	
	if ([user objectForKey:@"id"] != nil) {
		
		self.flashMessageView.backgroundColor = [UIColor greenColor];
		self.flashMessageLabel.textColor = [UIColor whiteColor];
		self.flashMessageLabel.text = @"Login successful!";
		self.loginActivityView.hidden = YES;
		self.flashMessageView.hidden = NO;
		
		
		[[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
		[[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
		
		//[self performSelector:@selector(dismissModalViewControllerAnimated:) withObject:nil afterDelay:1];
		
		
		
		dispatch_queue_t delay_queue = dispatch_queue_create("delay_queue", NULL);
		dispatch_async(delay_queue, ^{
			[NSThread sleepForTimeInterval:1];
			dispatch_async(dispatch_get_main_queue(), ^{
				self.flashMessageView.hidden = YES;
				[self dismissModalViewControllerAnimated:YES];
			});
		});
		
		dispatch_release(delay_queue);
		
		if (successfulLoginObject != nil && successfulLoginSelector != nil) {
			[successfulLoginObject performSelector:successfulLoginSelector];
		}
		
	}
	else {
		
		self.flashMessageView.backgroundColor = [UIColor redColor];
		self.flashMessageLabel.textColor = [UIColor yellowColor];
		self.flashMessageLabel.text = @"Unable to log in!";
		self.loginActivityView.hidden = YES;
		self.flashMessageView.hidden = NO;
		
	}
	
}


- (IBAction)cancelLogin {
	[self dismissModalViewControllerAnimated:YES];
}


@end

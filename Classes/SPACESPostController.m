//
//  SPACESPostController.m
//  SPACES
//
//  Created by Michael Wang on 7/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPACESPostController.h"
#import "PhotoPickerViewController.h"
#import "LoginViewController.h"
#import "SubmissionsPhotoSource.h"

#define kToolbarHeight			59.0

@implementation SPACESPostController

@synthesize spacesURL;
@synthesize spacesTag;
@synthesize spacesWebView;
@synthesize toolbar;
@synthesize shade;
//@synthesize loadWebIndicatorView;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
- (void)loadView {	
}
*/

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGRect viewBounds = self.view.bounds;
	CGRect webFrame = CGRectMake(0, 0, viewBounds.size.width, viewBounds.size.height - kToolbarHeight);
	self.spacesWebView = [[[UIWebView alloc] initWithFrame:webFrame] autorelease];
	self.spacesWebView.delegate = self;
	self.spacesWebView.backgroundColor = [UIColor blackColor];
	self.spacesWebView.scalesPageToFit = YES;
	self.spacesWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.spacesWebView.delegate = self;
	[self.view addSubview: self.spacesWebView];
	
	[self.spacesWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.spacesURL]]];
	
	self.shade = [[UIView alloc] initWithFrame:self.view.frame];
	shade.backgroundColor = [UIColor blackColor];
	shade.alpha = 0.7;
	
	CGRect t = shade.frame;
	t.origin.y = 0;
	shade.frame = t;

	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	CGRect f = spinner.frame;
	f.origin.x = self.view.frame.size.width /2 - f.size.width/2;
	f.origin.y = self.view.frame.size.height /2 - f.size.height/2 - 50;
	spinner.frame = f;
	[spinner startAnimating];
	[shade addSubview:spinner];
	[spinner release];  
	
	// figure out the actual location to place the toolbar
	// !!! ========================================================== !!!
	CGRect toolFrame = CGRectMake(0, self.view.frame.size.height - kToolbarHeight-90, viewBounds.size.width, kToolbarHeight);
	
	self.toolbar = [[[UIToolbar alloc] initWithFrame:toolFrame] autorelease];
	self.toolbar.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];

	UIBarButtonItem *submission = [[UIBarButtonItem alloc] 
								   initWithTitle:@"View All Photo Submissions" style:UIBarButtonItemStyleBordered target:self action:@selector(reviewSubmissions)];
	UIBarButtonItem *submit = [[UIBarButtonItem alloc] 
							   initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(submitPhoto)];
	self.navigationItem.rightBarButtonItem = submit;
	
	UIBarButtonItem *space = [[UIBarButtonItem alloc] 
							  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	[self.toolbar setItems:[NSArray arrayWithObjects:space,submission,space,nil] animated:YES];
	
	[submission release];
	[submit release];
	[space release];
	
	
	//self.loadWebIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	//[self.loadWebIndicatorView release];
	//[self.loadWebIndicatorView startAnimating];
	[self.view addSubview:self.toolbar];
}


/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)reviewSubmissions{
	
	NSString *removed_hash_from_tag = [spacesTag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	removed_hash_from_tag = [removed_hash_from_tag stringByReplacingOccurrencesOfString:@"#" withString:@""];
	SubmissionsPhotoSource *cont = [[SubmissionsPhotoSource alloc] initWithTwitterTag:removed_hash_from_tag];
	[self.navigationController pushViewController:cont animated:YES];
	[cont release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
	// Releases the view if it doesn't have a superview.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[shade release];
	[spacesURL release];
	[spacesTag release];
	[spacesWebView release];
	[toolbar release];
    [super dealloc];
}





#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self.view.superview addSubview:shade];
	
	//[self.loadWebIndicatorView startAnimating];
	//self.loadWebIndicatorView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[shade removeFromSuperview];
	
	//[self.loadWebIndicatorView stopAnimating];
	//self.loadWebIndicatorView.hidden = YES;
	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    [self.spacesWebView loadHTMLString:errorString baseURL:nil];
}



- (IBAction)submitPhoto {
	
	NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
	NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
	
	
	//check for user credentials
	if (username != nil && password != nil) {
		[self showPhotoPickerView];
		
	}
	else {
		LoginViewController *loginViewController = [[LoginViewController alloc] init];
		[loginViewController onSuccessfulLoginPerformSelector:@selector(showPhotoPickerView) withObject:self];
		
		loginViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelLogin)];
		
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
		[loginViewController release];
		
		[self.navigationController presentModalViewController:navController animated:YES];
		[navController release];
	}
}

- (void)showPhotoPickerView {
	
	NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
	NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
	
	SpacesTwitterConnection *twitter = [[[SpacesTwitterConnection alloc] initWithDelegate:self] autorelease];
	[twitter setUsername:username andPassword:password];
	
	PhotoPickerViewController *pickerController = [[PhotoPickerViewController alloc] init];
	[self.navigationController pushViewController:pickerController animated:YES];
	[pickerController release];
	
	pickerController.twitter = twitter;
	pickerController.challengeIdentifier = spacesTag;
	
}


-(void)cancelLogin {
	[self dismissModalViewControllerAnimated:YES];
}


@end

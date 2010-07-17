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

#define kLeftMargin             20.0
#define kRightMargin            20.0
#define kToolbarHeight			44.0

@implementation SPACESPostController

@synthesize spacesWebView;
@synthesize spacesURL;
@synthesize spacesTag;
@synthesize toolbar;

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

- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGRect viewBounds = self.view.bounds;
	
		
	CGRect webFrame = CGRectMake(0, 0, viewBounds.size.width, viewBounds.size.height - kToolbarHeight);
	self.spacesWebView = [[[UIWebView alloc] initWithFrame:webFrame] autorelease];
	self.spacesWebView.backgroundColor = [UIColor whiteColor];
	self.spacesWebView.scalesPageToFit = YES;
	self.spacesWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.spacesWebView.delegate = self;
	[self.view addSubview: self.spacesWebView];
	
	[self.spacesWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.spacesURL]]];
	
	
	
	
	// gigure out the actual location of toolbar
	CGRect toolFrame = CGRectMake(0, self.view.frame.size.height - kToolbarHeight-90, viewBounds.size.width, kToolbarHeight);
	
	self.toolbar = [[[UIToolbar alloc] initWithFrame:toolFrame] autorelease];
	
	UIBarButtonItem *submission = [[UIBarButtonItem alloc] initWithTitle:@"Submissions" style:UIBarButtonItemStyleBordered target:self action:@selector(reviewSubmissions)];
	UIBarButtonItem *submit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(submitPhoto)];
	UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[self.toolbar setItems:[NSArray arrayWithObjects:space, submission, submit, space, nil] animated:YES];	
	
	[self.view addSubview:self.toolbar];
	
}

/*
- (void)viewWillAppear:(BOOL)animated {
    self.spacesWebView.delegate = self;
}
 */

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[spacesURL release];
	[spacesTag release];
	[spacesWebView release];
    [super dealloc];
}





#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
	
	//check for user credentials
	if (YES) {
		PhotoPickerViewController *pickerController = [[PhotoPickerViewController alloc] init];
		[self.navigationController presentModalViewController:pickerController animated:YES];
		[pickerController release];
	}
	else {
		LoginViewController *loginViewController = [[LoginViewController alloc] init];
		[self.navigationController presentModalViewController:loginViewController animated:YES];
		[loginViewController release];
	}
}

@end

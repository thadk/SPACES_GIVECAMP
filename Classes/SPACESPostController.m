//
//  SPACESPostController.m
//  SPACES
//
//  Created by Michael Wang on 7/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPACESPostController.h"

#define kLeftMargin             20.0
#define kRightMargin            20.0

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

	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	
	CGRect toolFrame = CGRectMake(0, appFrame.size.height - 40, appFrame.size.width, 40);
	self.toolbar = [[[UIToolbar alloc] initWithFrame:toolFrame] autorelease];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(imagePicker)];
	UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[toolbar setItems:[NSArray arrayWithObjects:space, item, space, nil] animated:NO];	
	
	
	[self.view addSubview:self.toolbar];
	
	CGRect webFrame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height - 40);
	self.spacesWebView = [[[UIWebView alloc] initWithFrame:webFrame] autorelease];
	self.spacesWebView.backgroundColor = [UIColor whiteColor];
	self.spacesWebView.scalesPageToFit = YES;
	self.spacesWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.spacesWebView.delegate = self;
	[self.view addSubview: self.spacesWebView];
	
	[self.spacesWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.spacesURL]]];
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

@end

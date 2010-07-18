//
//  AboutViewController.m
//  SPACES
//
//  Created by Joe Cannatti on 7/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

@synthesize webView;
@synthesize shade;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	NSString *urlAddress = @"http://bloggedupspaces.org/digispaces/";
	NSURL *url = [NSURL URLWithString:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webView loadRequest:requestObj];
	
	self.shade = [[UIView alloc] initWithFrame:self.view.frame];
	shade.backgroundColor = [UIColor blackColor];
	shade.alpha = 0.7;
	
	
	CGRect t = shade.frame;
	t.origin.y = 0;
	shade.frame = t;
	
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	CGRect f = spinner.frame;
	f.origin.x = self.view.frame.size.width /2 - f.size.width/2;
	f.origin.y = self.view.frame.size.height /2 - f.size.height/2 - 20;
	spinner.frame = f;
	[spinner startAnimating];
	[shade addSubview:spinner];
	[spinner release];  
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
	[self.view addSubview:shade];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[shade removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	[shade removeFromSuperview];
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
	[webView release];
	if(shade)[shade release], shade = nil;
    [super dealloc];
}


@end

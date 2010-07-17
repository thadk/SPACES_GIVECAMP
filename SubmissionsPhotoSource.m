    //
//  SubmissionsPhotoSource.m
//  SPACES
//
//  Created by Joe Cannatti Jr on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SubmissionsPhotoSource.h"


@implementation SubmissionsPhotoSource
@synthesize tag;
@synthesize twitter;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithTwitterTag:(NSString*)_tag{
    if ((self = [super init])) {
			self.tag = _tag;
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
  	twitter = [[SpacesTwitterConnection alloc] initWithDelegate:self];
		[twitter getSubmissionsForTag:@"#clegivecamp"];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark CALLBACK

//- (void)requestSucceeded:(NSString *)connectionIdentifier{
//	int i = 9;
//}
//- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error{
//	int i = 9;
//}
//- (void)searchResultsReceived:(NSArray *)searchResults forRequest:(NSString *)connectionIdentifier{
//	int i = 9;
//	
//}
- (void)statusesReceived:(NSArray *)_statuses forRequest:(NSString *)connectionIdentifier{
	int i = 9;
}

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
    [super dealloc];
}


@end

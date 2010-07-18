    //
//  SubmissionsPhotoSource.m
//  SPACES
//
//  Created by Joe Cannatti Jr on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SubmissionsPhotoSource.h"
#import "MockPhotoSource.h"
#import "SBJSON.h"

@implementation SubmissionsPhotoSource
@synthesize tag;
@synthesize twitter;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithTwitterTag:(NSString*)_tag{
    if ((self = [super init])) {
			self.tag = _tag;
			self.title = _tag;
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.tintColor = [UIColor magentaColor];
	self.navigationBarStyle = UIBarStyleBlack;
	self.navigationBarTintColor = [UIColor magentaColor];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];	

	self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[self getChallangeSubmission:tag ? : @"SPC097"];
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

- (void)searchResultsReceived:(NSArray *)searchResults forRequest:(NSString *)connectionIdentifier{
	//int i = 9;
}

-(void)getChallangeSubmission:(NSString*)_tag{
	
	shade = [[UIView alloc] initWithFrame:self.view.frame];
	shade.backgroundColor = [UIColor blackColor];
	shade.alpha = 0.7;
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 31/2, self.view.frame.size.height/2 - 31/2, 31, 31)];
	[spinner startAnimating];
	[shade addSubview:spinner];
	[spinner release];
	[self.view addSubview:shade];
	
	NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://bloggedupspaces.org/tweetapp/submissionJSON.php?SPChashtag=%@",_tag]]];
	NSHTTPURLResponse *res = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
	SBJSON *sb = [[SBJSON alloc]init];
  NSDictionary *results = [sb objectWithString:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
	[self statusesReceived:[results objectForKey:@"results"] forRequest:@"m"];
	//int i =9;
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier{
	NSMutableArray *twitPics = [[NSMutableArray alloc] initWithCapacity:50];
	for (NSDictionary *cur in statuses) {
		NSString *text = [cur objectForKey:@"text"];
		NSLog(@"cur: ---- %@",text);
		NSError *error = nil;
		NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http://(www\\.)?twitpic\\.com/[^ ]+" options:0 error:&error];
		
		NSString *link = nil;
		if(text){
			NSArray *comps = [regex matchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length])];
			if([comps count]){
				NSRange range = [[comps objectAtIndex:0] range];
				link = [text substringWithRange:range];
			}
		}
		if (link) {
			NSString *ID = [link	lastPathComponent];
			
			NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:cur];
			
			NSString *imageFull = [NSString stringWithFormat:@"http://twitpic.com/show/large/%@.png",ID];
			NSLog(@"Image Full: %@",imageFull);
			[dict setObject:imageFull forKey:@"spaces_full_images_path"];
			
			NSString *imageThumb = [NSString stringWithFormat:@"http://twitpic.com/show/thumb/%@.png",ID];
			NSLog(@"Image Thumb: %@",imageThumb);
			[dict setObject:imageThumb forKey:@"spaces_thumb_images_path"];
			
			
			[twitPics addObject:dict];
		}
	}
	
	NSMutableArray *mockPics = [NSMutableArray arrayWithCapacity:20];
	for(NSDictionary *cur in twitPics){
		MockPhoto *photo = [[MockPhoto alloc] initWithURL:[cur objectForKey:@"spaces_full_images_path"] smallURL:[cur objectForKey:@"spaces_thumb_images_path"] size:CGSizeZero];
		[mockPics addObject:photo];
		[photo release];
	}
	self.photoSource = [[MockPhotoSource alloc] initWithType:MockPhotoSourceNormal title:tag ? : @"SPACES" photos:mockPics photos2:mockPics];
	[self reload];
	
	if (shade) {
		[shade removeFromSuperview];
		[shade release];
		shade = 0;
	}
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

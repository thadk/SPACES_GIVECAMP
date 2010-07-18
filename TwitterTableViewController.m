//
//  TwitterTableViewController.m
//  SPACES
//
//  Created by Joe Cannatti Jr on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterTableViewController.h"
#import "SPACESPostController.h"
#import "CustomSpacesCell.h"
#import "LoginViewController.h"
#import "SPACESAppDelegate.h"
@implementation TwitterTableViewController
@synthesize statuses,twitter,shade;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMM dd, yyyy HH:mm"];
	self.title = @"SPACES";
	self.statuses = nil;
	
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
	
	UIBarButtonItem *follow = [[UIBarButtonItem alloc] initWithTitle:@"Follow" style:UIBarButtonItemStyleBordered target:self action:@selector(displayAction)];
	self.navigationItem.leftBarButtonItem = follow;
	[follow release];
	
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	[self performSelectorInBackground:@selector(getData) withObject:nil];
	[self.view addSubview:shade];
}
-(void)getData{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	twitter = [[SpacesTwitterConnection alloc ]initWithDelegate:self];
	[twitter performSelectorOnMainThread:@selector(getAllSpacesTweets) withObject:nil waitUntilDone:NO];
	[pool drain];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)displayAction{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"We're on Twitter!"  
																										 delegate:self 
																						cancelButtonTitle:@"Cancel" 
																			 destructiveButtonTitle:nil 
																						otherButtonTitles:@"Follow Us",nil];
	[sheet showFromTabBar:[SPACESAppDelegate sharedDelegate].tabBar];

	[sheet release];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 0) {
		[self follow];
	}
}
-(void)follow{
	NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
	NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
	
	
	//check for user credentials
	if (username != nil && password != nil) {
		
		
		[twitter setUsername:username andPassword:password];
		[twitter checkUserCredentials];
		[twitter followSPACES];
		
	}
	else {
		LoginViewController *loginViewController = [[LoginViewController alloc] init];
		
		loginViewController.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];
		loginViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelLogin)];
		
		
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
		[loginViewController release];
		
		
		[self.navigationController presentModalViewController:navController animated:YES];
		[navController release];
	}
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSLog(@"Rows %d", [statuses count]);
    return ([statuses count] >= 5) ? ([statuses count] + 1) : 6;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomSpacesCell";
    
    CustomSpacesCell *cell = (CustomSpacesCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomSpacesCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects)
		{
			if ([currentObject isKindOfClass:[UITableViewCell class]])
			{
				cell = (CustomSpacesCell *) currentObject;
				break;
			}
		}
    }
    
    // Configure the cell...
	cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"gradient.png"] 	stretchableImageWithLeftCapWidth:0 topCapHeight:53]];
	cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"gradient.png"] 	stretchableImageWithLeftCapWidth:0 topCapHeight:53]];
	if (indexPath.row == [statuses count])
	{
		cell.published.text = @"";
		cell.status.text = @"   LOAD MORE...";
		cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pink_gradient.png"] 	stretchableImageWithLeftCapWidth:0 topCapHeight:53]];
		cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pink_gradient.png"] 	stretchableImageWithLeftCapWidth:0 topCapHeight:53]];
	}
	else if(indexPath.row < [statuses count])
	{
		NSDictionary* response = [statuses objectAtIndex: indexPath.row];
		NSNumber *dateNum = [response objectForKey: @"created_at"];
		NSDate *date = [NSDate dateWithTimeIntervalSince1970: [dateNum intValue]];
		NSString *dateStr = [format stringFromDate:date];
		cell.published.text = dateStr;		
		cell.status.text = [[response objectForKey: @"text"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	[cell setBackgroundColor:[UIColor clearColor]];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	UIFont *font = [UIFont fontWithName:@"Helvetica" size:13.0f];
	CGSize size = CGSizeMake([[self tableView] frame].size.width - 40.0, FLT_MAX);
	CGSize calcSize;
    if (indexPath.row == [statuses count])
	{
		calcSize = [@"   LOAD MORE..." sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
		return 44;
	}
	else if (indexPath.row >= [statuses count])
	{
		return 85;
	}

	else
	{
		 calcSize = [[[statuses objectAtIndex:indexPath.row] objectForKey:@"text"] 
					 sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
		return calcSize.height + 35;
	}
//	
//	return calcSize.height + 35;
//    return [indexPath row] * 1.5 + 20;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
//	SPACESPostController *detailedViewController = [[SPACESPostController alloc] init];
//	detailedViewController.spacesURL = @"http://apple.com";
//	detailedViewController.spacesTag = @"ABC";
//	
//	// Pass the selected object to the new view controller.
//	[self.navigationController pushViewController:detailedViewController animated:YES];
//	[detailedViewController release];
	
    if (indexPath.row == [statuses count])
	{
		[twitter getSomeSpacesTweets: [statuses count]+20];
	}
}

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
	NSMutableArray *tempStatuses = [NSMutableArray arrayWithArray: _statuses];
	for (int i=[tempStatuses count]-1; i>=0; i--) 
	{
		NSString *text = [[tempStatuses objectAtIndex: i] objectForKey: @"text"];
		NSRange range = [text rangeOfString:@"#SPC"];
		if (range.location != NSNotFound)
		{
			[tempStatuses removeObjectAtIndex: i];
		}
	}
	self.statuses = [NSArray arrayWithArray: tempStatuses];
	
	[shade removeFromSuperview];

	
	
	[self.tableView reloadData];
}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[format release];
	if(twitter)[twitter release];
    [super dealloc];
}


@end


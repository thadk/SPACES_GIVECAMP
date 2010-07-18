//
//  ChallengeTableViewController.m
//  SPACES
//
//  Created by Troy Sartain on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ChallengeTableViewController.h"
#import "SPACESPostController.h"
#import "CustomChallengesCell.h"
#import "SBJSON.h"
@implementation ChallengeTableViewController
@synthesize statuses, twitter;

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
	self.title = @"Challenges";

}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];

	NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://bloggedupspaces.org/tweetapp/announcementJSON.php"]];
	NSHTTPURLResponse *res = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:nil];
	SBJSON *sb = [[SBJSON alloc]init];
  NSDictionary *results = [sb objectWithString:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
	self.statuses = [results objectForKey:@"results"];
	
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [statuses count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomChallengesCell";
    
    CustomChallengesCell *cell = (CustomChallengesCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomChallengesCell" owner:nil options:nil];
		for (id currentObject in topLevelObjects)
		{
			if ([currentObject isKindOfClass:[UITableViewCell class]])
			{
				cell = (CustomChallengesCell *) currentObject;
				break;
			}
		}
		//		for (int currentObject in topLevelObjects)
		//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[statuses objectAtIndex:indexPath.row] objectForKey:@"text"];
  	cell.textLabel.font = [UIFont systemFontOfSize:15];
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
  	cell.textLabel.numberOfLines = 0;

	NSDictionary* response = [statuses objectAtIndex: indexPath.row];
	NSNumber *dateNum = [response objectForKey: @"created_at"];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970: [dateNum intValue]];
	NSString *dateStr = [format stringFromDate:date];
	cell.published.text = dateStr;
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	UIFont *font = [UIFont boldSystemFontOfSize:15];
	CGSize size = CGSizeMake([[self tableView] frame].size.width - 20.0, FLT_MAX);
	CGSize calcSize = [[[statuses objectAtIndex:indexPath.row] objectForKey:@"text"] sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
	
	return calcSize.height;
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
	
	NSString *hashTag = @"";
    NSString *statusText = [[statuses objectAtIndex:indexPath.row] objectForKey:@"text"];
	NSArray *chunks = [statusText componentsSeparatedByString: @" "];
	for (NSString *word in chunks)
	{	
		NSRange range = [word rangeOfString:@"#SPC" options:NSCaseInsensitiveSearch];
		if (range.location != NSNotFound)
		{
			hashTag = word;
			break;
		}
	}
	
	NSString *spacesURL = @"";
	for (NSString *word in chunks)
	{	
		NSRange range = [word rangeOfString:@"http"];
		if (range.location != NSNotFound)
		{
			spacesURL = word;
			break;
		}
	}
	
	SPACESPostController *detailedViewController = [[SPACESPostController alloc] init];
	detailedViewController.spacesURL = spacesURL;
	detailedViewController.spacesTag = hashTag;
	
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailedViewController animated:YES];
	[detailedViewController release];
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
		NSRange range = [text rangeOfString:@"#Daily"];
		if (range.location == NSNotFound)
		{
			[tempStatuses removeObjectAtIndex: i];
		}
	}
	self.statuses = [NSArray arrayWithArray: tempStatuses];
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
    [super dealloc];
}


@end



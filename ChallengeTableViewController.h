//
//  ChallengeTableViewController.h
//  SPACES
//
//  Created by Troy Sartain on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChallengeTableViewController : UITableViewController 
{
	NSArray *statuses;
}

@property (nonatomic, retain) NSArray *statuses;

@end
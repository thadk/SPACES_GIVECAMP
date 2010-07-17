//
//  ChallengeTableViewController.h
//  SPACES
//
//  Created by Troy Sartain on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpacesTwitterConnection.h"


@interface ChallengeTableViewController : UITableViewController 
{
	NSArray *statuses;
	SpacesTwitterConnection *twitter;
}

@property (nonatomic, retain) NSArray *statuses;
@property (nonatomic, retain) SpacesTwitterConnection *twitter;

@end
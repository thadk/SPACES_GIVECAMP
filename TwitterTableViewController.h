//
//  TwitterTableViewController.h
//  SPACES
//
//  Created by Joe Cannatti Jr on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpacesTwitterConnection.h"


@interface TwitterTableViewController : UITableViewController {
	NSArray *statuses;
	SpacesTwitterConnection *twitter;
	NSDateFormatter *format;
	
	UIView *shade;
}

-(void)logout;

@property(nonatomic,retain)NSArray *statuses;
@property(nonatomic,retain)SpacesTwitterConnection *twitter;
@property(nonatomic,retain)UIView *shade;
@end

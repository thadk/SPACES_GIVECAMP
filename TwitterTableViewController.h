//
//  TwitterTableViewController.h
//  SPACES
//
//  Created by Joe Cannatti Jr on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TwitterTableViewController : UITableViewController {
	NSArray *statuses;
}
@property(nonatomic,retain)NSArray *statuses;
@end

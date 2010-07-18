//
//  CustomChallengesCell.h
//  SPACES
//
//  Created by Troy Sartain on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomChallengesCell : UITableViewCell 
{
	IBOutlet UILabel *status;
	IBOutlet UILabel *published;
}

@property (nonatomic, retain) IBOutlet UILabel *status;
@property (nonatomic, retain) IBOutlet UILabel *published;

@end

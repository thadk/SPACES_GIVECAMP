//
//  SubmissionsPhotoSource.h
//  SPACES
//
//  Created by Joe Cannatti Jr on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "SpacesTwitterConnection.h"
@interface SubmissionsPhotoSource : TTThumbsViewController {
	NSString *tag;
	SpacesTwitterConnection *twitter;
	UIView *shade;
}

-(void)getChallangeSubmission:(NSString*)_tag;

@property(nonatomic,retain)NSString *tag;
@property(nonatomic,retain)SpacesTwitterConnection *twitter;
@end

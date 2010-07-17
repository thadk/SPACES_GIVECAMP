//
//  SpacesTwitterConnection.m
//  SPACES
//
//  Created by Joe Cannatti on 7/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpacesTwitterConnection.h"
#import "NSString+UUID.h"

@implementation SpacesTwitterConnection

static MGTwitterEngine* twitter;

+(MGTwitterEngine *) sharedConnection 
{
	return twitter;
}

+(void) initializeWithDelegate:(id)delegate
{
	twitter = [[MGTwitterEngine alloc] initWithDelegate:delegate]; 
}

+(void)setUsername:(NSString*)username andPassword:(NSString*)password
{
	[twitter setUsername:username password:password]; 
}

+(NSString*)getAllSpacesTweets{
	NSString *ret = [twitter getUserTimelineFor:@"spacesgallery" sinceID:0 startingAtPage:0 count:100];
	return ret;
}




@end

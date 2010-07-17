//
//  SpacesTwitterConnection.m
//  SPACES
//
//  Created by Joe Cannatti on 7/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpacesTwitterConnection.h"


@implementation SpacesTwitterConnection

static MGTwitterEngine* twitter;

+(MGTwitterEngine *) sharedConnection 
{
	return twitter;
}

+(void) initializeTwitterWithUsername: (NSString *)username andPassword: (NSString *)password withDelegate: (id)delegate
{
	MGTwitterEngine *twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:delegate]; 
	[twitterEngine setUsername:username password:password]; 
	
	// Get updates from people the authenticated user follows. 
//	NSString *connectionID = [twitterEngine getFollowedTimelineFor:nil since:nil startingAtPage:0];
}

@end

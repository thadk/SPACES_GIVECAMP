//
//  SpacesTwitterConnection.h
//  SPACES
//
//  Created by Joe Cannatti, Troy Sartain on 7/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MGTwitterEngine.h>


@interface SpacesTwitterConnection : NSObject 
{
	MGTwitterEngine* twitter;

}
@property(nonatomic,retain)	MGTwitterEngine* twitter;


+(MGTwitterEngine *) sharedConnection;
+(void)initializeWithDelegate:(id)delegate;
+(void)setUsername:(NSString*)username andPassword:(NSString*)password;
+(NSString*)getAllSpacesTweets;
+(void) uploadPicAndPost: (UIImage *)pic andMessage:(NSString *)msg;
@end

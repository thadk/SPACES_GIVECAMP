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
	id sender;

}
@property(nonatomic,retain)	MGTwitterEngine* twitter;


-(id) initWithDelegate: (id)_delegate;
-(void)setUsername:(NSString*)username andPassword:(NSString*)password;
-(NSString *) getChallengeTweets;
-(NSString*)getAllSpacesTweets;
-(NSString*)getSomeSpacesTweets: (int) cnt;
-(void) uploadPicAndPost: (UIImage *)pic andMessage:(NSString *)msg sender:(id)sender;
-(NSString *)checkUserCredentials;
-(NSString*)getSubmissionsForTag:(NSString*)_tag;
-(void)followSPACES;
@end

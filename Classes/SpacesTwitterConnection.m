//
//  SpacesTwitterConnection.m
//  SPACES
//
//  Created by Joe Cannatti, Troy Sartain on 7/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpacesTwitterConnection.h"
#import "NSString+UUID.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

@implementation SpacesTwitterConnection
@synthesize twitter;

-(id) initWithDelegate:(id)_delegate
{
	if (self = [super init]) {
		self.twitter = [[MGTwitterEngine alloc] initWithDelegate:_delegate]; 
		return self;
	}
	else {
		return nil;
	}	
}

-(void)setUsername:(NSString*)username andPassword:(NSString*)password{
	[twitter setUsername:username password:password];
}

-(void)followSPACES{
		[twitter enableUpdatesFor:@"spacesgallery"];
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You are now following SPACES" message:@"Nice to meet you." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
}

-(NSString*)getAllSpacesTweets
{
	NSString *ret = [twitter getUserTimelineFor:@"spacesgallery" sinceID:0 startingAtPage:0 count:20];
	NSLog(ret,nil);
	return ret;
}

-(NSString*)getSomeSpacesTweets: (int) cnt
{
	NSString *ret = [twitter getUserTimelineFor:@"spacesgallery" sinceID:0 startingAtPage:0 count:cnt];
	NSLog(ret,nil);
	return ret;
}

-(NSString *) getChallengeTweets
{
//	NSString *url = @"from:spacesgallery+#DailyArtDose";
//	NSString *ret = [twitter getSearchResultsForQuery:url];
	NSString *ret = [twitter getUserTimelineFor:@"spacesgallery" sinceID:0 startingAtPage:0 count:52];
	NSLog(ret,nil);
	return ret;
}

-(void) uploadPicAndPost: (UIImage *)pic andMessage:(NSString *)msg sender:(id)_sender
{
	
	NSData *imageData = UIImageJPEGRepresentation(pic, .90);
	

	NSURL *twitpicURL = [NSURL URLWithString:@"http://twitpic.com/api/uploadAndPost"];
	
	ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:twitpicURL] autorelease];
	
	[request setData:imageData forKey:@"media"];
	[request setPostValue:twitter.username forKey:@"username"];
	[request setPostValue:twitter.password forKey:@"password"];
	[request setPostValue:msg forKey:@"message"];
	
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDone:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	
	[request start];
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	
	sender = _sender;
}

- (void)requestDone:(ASIHTTPRequest *)request {
	CFShow(request);
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	if ([sender respondsToSelector:@selector(submissionSuccessful)]) {
		[sender performSelectorOnMainThread:@selector(submissionSuccessful) withObject:nil waitUntilDone:NO];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	CFShow(request);
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	if ([sender respondsToSelector:@selector(submissionFailed)]) {
		[sender performSelectorOnMainThread:@selector(submissionFailed) withObject:nil waitUntilDone:NO];
	}
}

-(NSString*)getSubmissionsForTag:(NSString*)_tag{

	return [twitter getSearchResultsForQuery:_tag];
}

- (NSString *)checkUserCredentials {
	return [twitter checkUserCredentials];
}


@end

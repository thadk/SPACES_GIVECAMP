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

+(void) initializeWithDelegate: (id)delegate
{
	twitter = [[MGTwitterEngine alloc] initWithDelegate:delegate]; 
}

+(void) setUsername: (NSString*)username andPassword:(NSString*)password
{
	[twitter setUsername:username password:password]; 
}

+(NSString*)getAllSpacesTweets{
	NSString *ret = [twitter getUserTimelineFor:@"spacesgallery" sinceID:0 startingAtPage:0 count:100];
	return ret;
}

+(void) uploadPicAndPost: (UIImage *)pic andMessage:(NSString*)msg
{
	// create the URL
	NSURL *postURL = [NSURL URLWithString:@"http://twitpic.com/api/uploadAndPost"];
	
	// create the connection
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL
															   cachePolicy:NSURLRequestUseProtocolCachePolicy
														   timeoutInterval:30.0];
	
	// change type to POST (default is GET)
	[postRequest setHTTPMethod:@"POST"];
	
	// just some random text that will never occur in the body
	NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
	
	// header value
	NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
								stringBoundary];
	
	// set header
	[postRequest addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
	
	// create data
	NSMutableData *postBody = [NSMutableData data];
	
	NSString *username = twitter.username;
	NSString *password = twitter.password;
	NSString *message = msg;
	
	// username part
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[username dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// password part
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// message part
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[message dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// media part
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Disposition: form-data; name=\"media\"; filename=\"dummy.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// get the image data from main bundle directly into NSData object
	
	NSData *imageData = UIImageJPEGRepresentation(pic, .90);
	
	// add it to body
	[postBody appendData:imageData];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	// final boundary
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// add body to post
	[postRequest setHTTPBody:postBody];
	
	// pointers to some necessary objects
	NSURLResponse* response;
	NSError* error;
	
	// synchronous filling of data from HTTP POST response
	NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
	
	if (error)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
	}
	
	// convert data into string
	NSString *responseString = [[[NSString alloc] initWithBytes:[responseData bytes]
														 length:[responseData length]
													   encoding:NSUTF8StringEncoding] autorelease];
	
	// see if we get a welcome result
	NSLog(@"%@", responseString);
	
	// create a scanner
	NSString *mediaURL = nil;
	NSScanner *scanner = [NSScanner scannerWithString:responseString];
	[scanner scanUpToString:@"<mediaurl>" intoString:nil];
	[scanner scanString:@"<mediaurl>" intoString:nil];
	[scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"<"] intoString:&mediaURL];
	
	NSLog(@"mediaURL is %@", mediaURL);
}


@end

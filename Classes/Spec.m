//
//  Spec.m
//  SPACES
//
//  Created by Joe Cannatti Jr on 7/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// TestSpec.m

#import "Kiwi.h"
#import "SpacesTwitterConnection.h"
SPEC_BEGIN(TestSpec)


//describe(@"SpacesTwitterConnection", ^{
//	it(@"works", ^{
//		// Try changing should to shouldNot, and vice-versa to see
//		// failures in action.
//		
//		id anArray = [NSArray arrayWithObject:@"Foo"];
//		[[anArray should] contain:@"Foo"];
//		[[anArray shouldNot] contain:@"Bar"];
//		
//		[[theValue(42) should] beGreaterThan:theValue(10.0f)];
//		[[theValue(42) shouldNot] beLessThan:theValue(20)];
//		
//		id scannerMock = [NSScanner mock];
//		[[scannerMock should] receive:@selector(setScanLocation:)];
//		[scannerMock setScanLocation:10];
//		
//		[scannerMock stub:@selector(string) andReturn:@"Unicorns"];
//		[[[scannerMock string] should] equal:@"Unicorns"];
//		
//		[[theBlock(^{
//			[NSException raise:NSInternalInconsistencyException format:@"oh-oh"];
//		}) should] raise];
//	});
//});

describe(@"SpacesTwitterConnection", ^{
	it(@"should instantiate", ^{
		// Try changing should to shouldNot, and vice-versa to see
		// failures in action.
		
		id mock = [NSObject mock];
		//[mock stub:@selector(string) andReturn:@"Unicorns"];
		[SpacesTwitterConnection initializeWithDelegate:mock];
		[[[SpacesTwitterConnection sharedConnection] shouldNot] equal:nil];
		
	});
	
	it(@"should return results for spaces tweeter feed", ^{
		// Try changing should to shouldNot, and vice-versa to see
		// failures in action.
		
		id mock = [NSObject mock];
		[mock stub:@selector(requestSucceeded:)];
		[SpacesTwitterConnection initializeWithDelegate:mock];
		NSString *tweets = [SpacesTwitterConnection getAllSpacesTweets];
		
		[[mock should] receive:@selector(requestSucceeded:)];
//		 - (void)requestSucceeded:(NSString *)connectionIdentifier;
//		 - (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error;
		
	});
	
});






SPEC_END

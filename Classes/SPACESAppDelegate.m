//
//  SPACESAppDelegate.m
//  SPACES
//
//  Created by Joe Cannatti Jr on 7/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SPACESAppDelegate.h"
#import "SPACESViewController.h"
#import "SpacesTwitterConnection.h"
#import "NSString+UUID.h"
#import "Reachability.h"
#import "NoReachabilityViewController.h"

@implementation SPACESAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize tabController;
@synthesize networkReachable;


#pragma mark -
#pragma mark Application lifecycle

+ (SPACESAppDelegate *)sharedDelegate {
	return (SPACESAppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (NSString *)twitterAccountName {
	return @"@galleryspaces";
}

+ (NSString *)twitterChallengePrefix {
	return @"#SPC";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
	NSLog(@"application");  
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];	
	
//	NSString *tweets = [SpacesTwitterConnection getAllSpacesTweets];
	//[[tweets shouldNot] equal:nil];
    // Override point for customization after application launch.
	
	// Test	+(void) uploadPicAndPost: (UIImage *)pic andMessage:(NSString *)msg  
//	NSLog(@"setUsername");
//	[SpacesTwitterConnection setUsername:@"spacesgallery" andPassword:@"spaces1978"];
//	UIImage* pic = [UIImage imageNamed:@"iphone.jpg"];
//	NSString* msg = @"test";
//	NSLog(@"uploadPicAndPost");
//	[SpacesTwitterConnection uploadPicAndPost:pic andMessage:msg];
//	NSLog(@"done");
	
	

    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
	
	
	
	noReachViewController = [[NoReachabilityViewController alloc] init];
	
    
	
	// Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
												 name:kReachabilityChangedNotification object:nil];
	
    // Monitoring Twitter
    twitterHostReachability = [[Reachability reachabilityWithHostName:@"www.twitter.com"] retain];
    [twitterHostReachability startNotifier];
    [self updateStateWithReachability:twitterHostReachability];
	
	
	[window makeKeyAndVisible];

    return YES;
}



// Called by Reachability whenever status changes.
- (void) reachabilityChanged:(NSNotification* )note {
	
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateStateWithReachability:curReach];
}


- (void) updateStateWithReachability: (Reachability*) curReach {
	
    if (curReach == twitterHostReachability) {
        
		NetworkStatus netStatus = [curReach currentReachabilityStatus];
        self.networkReachable = (netStatus != NotReachable);
		
    }
	
	// network is reachable
	if (self.networkReachable) {
		[noReachViewController dismissModalViewControllerAnimated:YES];
	}
	else {
		// present modal view
		 
		if (window.rootViewController.modalViewController != nil) {
			[window.rootViewController.modalViewController presentModalViewController:noReachViewController animated:YES];
		}
		else {
			
			[window.rootViewController presentModalViewController:noReachViewController animated:YES];
		}
		
	}
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
	[noReachViewController release];
	[twitterHostReachability release];
    [super dealloc];
}


@end

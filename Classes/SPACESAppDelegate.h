//
//  SPACESAppDelegate.h
//  SPACES
//
//  Created by Joe Cannatti Jr on 7/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPACESViewController;
@class Reachability;
@class NoReachabilityViewController;
@class SpacesTwitterConnection;

@interface SPACESAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SPACESViewController *viewController;
	IBOutlet UITabBarController *tabController;
	Reachability* twitterHostReachability;
	BOOL networkReachable;
	NoReachabilityViewController *noReachViewController;
	IBOutlet UITabBar *tabBar;
	BOOL twitterCredentialsChecked;
}

+ (SPACESAppDelegate *)sharedDelegate;
+ (NSString *)twitterAccountName;
+ (NSString *)twitterChallengePrefix;

-(void) updateStateWithReachability: (Reachability*) curReach;
-(void) checkTwitterCredentials;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SPACESViewController *viewController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabController;
@property (nonatomic) BOOL networkReachable;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;


@end


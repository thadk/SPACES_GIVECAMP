//
//  SPACESAppDelegate.h
//  SPACES
//
//  Created by Joe Cannatti Jr on 7/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPACESViewController;

@interface SPACESAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SPACESViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SPACESViewController *viewController;

@end


//
//  SPACESPostController.h
//  SPACES
//
//  Created by Michael Wang on 7/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPACESPostController : UIViewController <UIWebViewDelegate> {
	NSString *spacesURL;
	NSString *spacesTag;
	UIWebView *spacesWebView;
	UIToolbar *toolbar;
}

@property (nonatomic, retain) IBOutlet NSString *spacesURL;
@property (nonatomic, retain) IBOutlet NSString *spacesTag;
@property (nonatomic, retain) IBOutlet UIWebView *spacesWebView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

- (IBAction)submitPhoto;

@end

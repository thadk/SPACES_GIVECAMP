//
//  SignupViewController.h
//  SPACES
//
//  Created by Michael Wang on 7/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignupViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *signupWebView;

}

@property (nonatomic, retain) IBOutlet UIWebView *signupWebView;

@end

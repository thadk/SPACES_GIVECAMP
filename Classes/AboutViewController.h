//
//  AboutViewController.h
//  SPACES
//
//  Created by Joe Cannatti on 7/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController 
{
	IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) UIWebView *webView;

@end

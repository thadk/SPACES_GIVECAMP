//
//  PhotoPickerViewController.h
//  SPACES
//
//  Created by Randy Beiter on 7/17/10.
//  Copyright 2010 Sideways. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SpacesTwitterConnection.h"

@interface PhotoPickerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextViewDelegate> {
	IBOutlet UIButton *cancelButton;
	IBOutlet UIImageView *thumbnailView;
	IBOutlet UILabel *selectImageLabel;
	IBOutlet UITextView *messageView;
	IBOutlet UILabel *remainingCharsLabel;

	UIImage *fullImage;
	NSString *challengeIdentifier;
	SpacesTwitterConnection *twitter;
	UIImage *thumbnailImage;
	
	UIView *shade;
}

@property (nonatomic, retain) UIImage *fullImage;
@property (nonatomic, retain) NSString *challengeIdentifier;
@property (nonatomic, retain) SpacesTwitterConnection *twitter;
@property (nonatomic, retain) UIImage *thumbnailImage;
@property (nonatomic, retain) UIView *shade;

-(void) removeShade;
- (IBAction)submit:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)capture:(id)sender;

@end

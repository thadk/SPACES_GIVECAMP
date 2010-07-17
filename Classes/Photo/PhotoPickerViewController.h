//
//  PhotoPickerViewController.h
//  SPACES
//
//  Created by Randy Beiter on 7/17/10.
//  Copyright 2010 Sideways. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoPickerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
	UIButton *submitButton;
	UIImageView *thumbnailView;
	UILabel *selectImageLabel;
	UIImage *thumbnailImage;
	PhotoPickerViewController *photoController;
}

@property (nonatomic, retain) IBOutlet UIButton *submitButton;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnailView;
@property (nonatomic, retain) IBOutlet UILabel *selectImageLabel;
@property (nonatomic, retain) IBOutlet PhotoPickerViewController *photoController;
@property (nonatomic, retain) UIImage *thumbnailImage;

- (IBAction)submit:(id)sender;
- (IBAction)capture:(id)sender;

@end

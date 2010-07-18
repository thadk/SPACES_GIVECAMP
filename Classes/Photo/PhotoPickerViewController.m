//
//  PhotoPickerViewController.m
//  SPACES
//
//  Created by Randy Beiter on 7/17/10.
//  Copyright 2010 Sideways. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "SPACESAppDelegate.h"

#import <QuartzCore/QuartzCore.h>

@implementation PhotoPickerViewController

@synthesize fullImage;
@synthesize challengeIdentifier;
@synthesize twitter;
@synthesize thumbnailImage;

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	messageView.layer.cornerRadius=5;
	messageView.clipsToBounds = YES;
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(submit:)];

	[self updateRemainingCharsLabel];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
	
	// Create a thumbnail version of the image for the event object.
	self.fullImage = selectedImage;
	CGSize size = selectedImage.size;
	CGFloat ratio = 0;
	if (size.width > size.height) {
		ratio = thumbnailView.frame.size.width / size.width;
	}
	else {
		ratio = thumbnailView.frame.size.height / size.height;
	}
	CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
	
	UIGraphicsBeginImageContext(rect.size);
	[selectedImage drawInRect:rect];
	self.thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	[picker dismissModalViewControllerAnimated:YES];
	
	// push set/update off just a little - this avoids a bug where the image doesn't actually get set if updated too quickly
	dispatch_async(dispatch_get_main_queue(), ^{
		thumbnailView.image = thumbnailImage;
		[thumbnailView setNeedsDisplay];
	});
	
	// TOOD: send full size selectedImage either in a file or as UIImage if memory is ok to twitter poster
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	
	switch (buttonIndex) {
		case 0:
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
			break;
		case 1:
			imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			break;
		default:
			[imagePicker release];
			return;
	}
	
	[self presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
}

- (IBAction)capture:(id)sender {
	UIActionSheet *sourceActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Photo Source"
																   delegate:self
														  cancelButtonTitle:@"Cancel" 
													 destructiveButtonTitle:nil 
														  otherButtonTitles:@"Take New Photo", @"Use Existing Photo", nil];
	[sourceActionSheet showInView:self.view];
	[sourceActionSheet release];
}

- (IBAction)submit:(id)sender {
	// TODO: submit image to twitpic
	NSString *tweetMessage = [NSString stringWithFormat:@"%@ %@ %@", messageView.text, [SPACESAppDelegate twitterAccountName], self.challengeIdentifier];
	[twitter uploadPicAndPost:self.fullImage andMessage:tweetMessage];
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- text input delegate methods
- (int)maxTweetChars {
	int maxLength = 114 - ([[SPACESAppDelegate twitterAccountName] length] + 1) - ([self.challengeIdentifier length] + 1 + 3);
	return maxLength;
}

- (void)updateRemainingCharsLabelWithLength:(int)length {
	remainingCharsLabel.text = [NSString stringWithFormat:@"%d characters remaining.", [self maxTweetChars] - length];
	[remainingCharsLabel setNeedsDisplay];	
}

- (void)updateRemainingCharsLabel {
	[self updateRemainingCharsLabelWithLength:messageView.text.length];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	[textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		return NO;
	}

	int maxLength = [self maxTweetChars];
	
	if (maxLength > 0 && (textView.text.length + [text length]) > maxLength && range.length == 0) {
		return NO;
	}

	[self updateRemainingCharsLabelWithLength:messageView.text.length + text.length];
	
	return YES;
}


#pragma mark ---cleanup

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	if (fullImage) [fullImage release], fullImage = nil;
	if (challengeIdentifier) [challengeIdentifier release], challengeIdentifier = nil;
	if (thumbnailImage) [thumbnailImage release], thumbnailImage = nil;
	
    [super dealloc];
}


@end

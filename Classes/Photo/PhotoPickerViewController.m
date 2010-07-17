//
//  PhotoPickerViewController.m
//  SPACES
//
//  Created by Randy Beiter on 7/17/10.
//  Copyright 2010 Sideways. All rights reserved.
//

#import "PhotoPickerViewController.h"


@implementation PhotoPickerViewController

@synthesize selectImageLabel;
@synthesize submitButton;
@synthesize thumbnailView;
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


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
	
	// Create a thumbnail version of the image for the event object.
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
    [super dealloc];
}


@end

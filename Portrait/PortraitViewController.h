//
//  PortraitViewController.h
//  Portrait
//
//  Created by Qian Wang on 7/6/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortraitViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) UIImage *userPhoto;
@property (assign, nonatomic) BOOL didSelectPhoto;

- (IBAction)selectPhotoFromAlbum:(id)sender;

@end

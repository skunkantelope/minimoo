//
//  PopPortraitViewController.h
//  Portrait
//
//  Created by Qian Wang on 7/6/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//
#import "Pallette.h"
@interface PopPortraitViewController : UIViewController <PalletteDelegate>
- (IBAction)goBackToFaceDefine:(id)sender;

- (IBAction)mail:(id)sender;
- (IBAction)postTotwitter:(id)sender;

- (IBAction)saveToPhotos:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *drawingImage;
- (id)initWithImage:(UIImage *)anImage;

@end

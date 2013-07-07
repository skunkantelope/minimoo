//
//  PortraitViewController.m
//  Portrait
//
//  Created by Qian Wang on 7/6/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import "PortraitViewController.h"
#import "PortraitFaceDefineViewController.h"

@interface PortraitViewController () {
    BOOL didSelectPhoto;
}
@property (retain, nonatomic) UIImage *userPhoto;
@end

@implementation PortraitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    didSelectPhoto = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    if (didSelectPhoto) {
        // instantiate PortraitFaceDefineViewController
        PortraitFaceDefineViewController *viewController = [[PortraitFaceDefineViewController alloc] initWithImage:self.userPhoto];
        // todo: animating the time on detecting faces. some sort of magic
        
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectPhotoFromAlbum:(id)sender {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];

}

# pragma UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.userPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    didSelectPhoto = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

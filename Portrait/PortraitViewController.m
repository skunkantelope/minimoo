//
//  PortraitViewController.m
//  Portrait
//
//  Created by Qian Wang on 7/6/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import "PortraitViewController.h"
#import "PortraitFaceDefineViewController.h"
//#import "Signal.h"

@interface PortraitViewController () {
    BOOL didSelectPhoto;
    BOOL hasNoFaces;
//    Signal *glitterCircle;
    UIView *glitterCircle;
 // to detect face. Face detection is executed by PortraitViewController.
    CIContext *context;
    CIDetector *detector;
    
    NSArray *features;
}

//@property (retain) Signal *glitterCircle;
@property (retain) UIView *glitterCircle;
@property (retain) NSArray *features;
@property (retain) UIImageView *imageView;
- (void)detectFaces;

@end

@implementation PortraitViewController
@synthesize didSelectPhoto;
@synthesize glitterCircle;
@synthesize features;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    didSelectPhoto = NO;
    hasNoFaces = NO;
    
    self.glitterCircle = [[UIView alloc] initWithFrame:CGRectMake(75, 107, 13.5, 13.5)];
    glitterCircle.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:1.0 alpha:1.0];
    [self.view addSubview:glitterCircle];
    
    context = [CIContext contextWithOptions:nil];
    // create face detector object.
    NSDictionary *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];
}

- (void)viewDidAppear:(BOOL)animated {

    if (didSelectPhoto) {
        // instantiate PortraitFaceDefineViewController
    //    [glitterCircle.layer removeAllAnimations];

   //     UIView *photo = [[UIView alloc] initWithFrame:CGRectMake(126, 355, 145, 20)];
   //     photo.backgroundColor = [UIColor whiteColor];
   //     [self.view addSubview:photo];
        
      
            self.imageView = [[UIImageView alloc] initWithImage:self.userPhoto];
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            self.imageView.frame = CGRectMake(126, 148, 145, 227);
            //       self.imageView.hidden = YES;
            [self.view addSubview:self.imageView];


        [self detectFaces];
        
        

        
  /*      [UIView animateWithDuration:10
                              delay:0
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             self.imageView.hidden = NO;
                         }
                         completion:^(BOOL finished) {
                             
                         //    [photo removeFromSuperview];
                         //    [self.imageView removeFromSuperview];
                         }];
        */
        
        if (hasNoFaces) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No faces were found. Pick another picture." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Got it", nil];
            //       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No faces were found in this picture. Pick another picture." delegate:self cancelButtonTitle:@"Got it!" otherButtonTitles:nil];
            [alert show];
            
        } else {
            PortraitFaceDefineViewController *viewController = [[PortraitFaceDefineViewController alloc] initWithImage:self.userPhoto features:features andContext:context];
            // todo: animating the time on detecting faces. some sort of magic
            
            [self presentViewController:viewController animated:YES completion:nil];
            
            [self.imageView removeFromSuperview];
        }

    }
    
    [glitterCircle.layer removeAllAnimations];
    glitterCircle.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:1.0 alpha:1.0];
        
    
}

- (void)detectFaces {
    // call CIImage property of UIImage does not work or provide a valid CIImage.
    
    CIImage *image = [CIImage imageWithCGImage:[self.userPhoto CGImage]];
    //     NSDictionary *opts = [NSDictionary dictionaryWithObject:[[image properties] valueForKey:(NSString*)kCGImagePropertyOrientation] forKey:CIDetectorImageOrientation];
    self.features = [detector featuresInImage:image options:nil];
    
    // In case there are no faces detected, the scene goes back to the beginning scene.
    if ([features count] < 1) {
        hasNoFaces = YES;
        // todo: animation to tell user to pick a photo with faces.
        return;
    } else {
        hasNoFaces = NO;
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.imageView removeFromSuperview];
    
    self.userPhoto = nil;
    self.didSelectPhoto = NO;
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectPhotoFromAlbum:(id)sender {
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        
        [self presentViewController:pickerController animated:YES completion:nil];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionRepeat
                             animations: ^{
                                 glitterCircle.backgroundColor = [UIColor colorWithHue:0.3 saturation:1.0 brightness:0.7 alpha:1.0];
                                 
                             }
                             completion:^(BOOL finished) {
                                 glitterCircle.backgroundColor = [UIColor colorWithHue:0.0 saturation:1.0 brightness:0.7 alpha:1.0];
                                 
                             }];
        });
    });
  
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

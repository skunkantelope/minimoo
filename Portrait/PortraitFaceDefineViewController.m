//
//  PortraitFaceDefineViewController.m
//  Portrait
//
//  Created by Qian Wang on 7/6/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import "PortraitFaceDefineViewController.h"
#import "FaceRect.h"
#import "PortraitViewController.h"
#import "PopPortraitViewController.h"

@interface PortraitFaceDefineViewController () {
    CIContext *context;
    CIDetector *detector;
    
}
@property (retain, nonatomic) UIImage *image; // store a reference to the album photo
@property (retain, nonatomic) NSMutableArray *faces; // store UIImageView

- (void)detectFaces;
- (CIImage *)applyGreyScaleFilter:(CIImage *) image;
- (CIImage *)applyPixellateFilter:(CIImage *) image;
- (CIImage *)applySharpenFilter:(CIImage *) image;
- (CIImage *)applyMedianFilter:(CIImage *) image;
- (CIImage *)applyMinGreyScaleFilter:(CIImage *) image;
- (CIImage *)applyMaxGreyScaleFilter:(CIImage *) image;
- (CIImage *)applyDesaturationFilter:(CIImage *) image;
- (CIImage *)applyPosterizeFilter:(CIImage *) image;
- (void)renderQuartzImage:(CGImageRef) image;

@end

#define IMAGE_WIDTH 300
#define IMAGE_HEIGHT 400
#define X_OFFSET 10
#define Y_OFFSET 10

@implementation PortraitFaceDefineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        // create CI context object
        context = [CIContext contextWithOptions:nil];
        // create face detector object.
        NSDictionary *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
        detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];
        
        self.image = image;
        self.faces = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self detectFaces];
    
    // show the first face; view.tag = 30
    if (self.pageControl.numberOfPages > 0) {
        [self.view bringSubviewToFront:[self.faces objectAtIndex:0]];

    } 

}

- (void)detectFaces {
    // call CIImage property of UIImage does not work or provide a valid CIImage.
    CIImage *image = [CIImage imageWithCGImage:[self.image CGImage]];
 //     NSDictionary *opts = [NSDictionary dictionaryWithObject:[[image properties] valueForKey:(NSString*)kCGImagePropertyOrientation] forKey:CIDetectorImageOrientation];
    NSArray *features = [detector featuresInImage:image options:nil];
    
    int count = [features count];
    self.pageControl.numberOfPages = count;
    NSLog(@"number of faces: %i", count);
    // In case there are no faces detected, the scene goes back to the beginning scene.
    if (count < 1) {
        // todo: animation to tell user to pick a photo with faces.
        self.drawFace.enabled = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No faces were found in this picture. Pick another picture" delegate:nil cancelButtonTitle:@"Got it!" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
  
    for (CIFaceFeature *feature in features) {

        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(X_OFFSET, Y_OFFSET, IMAGE_WIDTH, IMAGE_HEIGHT);
        imageView.userInteractionEnabled = YES;
        
        // add face rect to imageview.
        // use utility functions to calculate the right frame for FaceRect
        float scale = scaleFactor(self.image.size, CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT));
        CGRect featureRect = userCoordinateFromGraphicsCoordinate(feature.bounds, self.image.size);
        CGRect featureFrame = pointFromPixel(featureRect, scale);
        
        FaceRect *faceRect = [[FaceRect alloc] initWithFrame:featureFrame];
        //[faceRect becomeFirstResponder];
        [imageView addSubview:faceRect];
       
        [self.faces addObject:imageView];
        
        [self.view addSubview:imageView];
    }
    
}

- (CIImage *) applyGreyScaleFilter:(CIImage *)image {

    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setValue:image forKey:@"inputImage"];
    CIColor *black = [CIColor colorWithRed:0.0 green:0.0 blue:0.0];
    [filter setValue:black forKey:@"inputColor"];
    return [filter valueForKey:@"outputImage"];
    
}

// Pixellate the resulting image.
- (CIImage *)applyPixellateFilter:(CIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
    [filter setValue:image forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:20.0] forKey:@"inputScale"];
  //  CIVector * position = [CIVector vectorWithX:0.0 Y:200.0];
  //  [filter setValue:position forKey:@"inputCenter"];
    return [filter valueForKey:@"outputImage"];
}

- (CIImage *)applyMaxGreyScaleFilter:(CIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CIMaximumComponent"];
    [filter setValue:image forKey:@"inputImage"];
    return [filter valueForKey:@"outputImage"];
}

- (CIImage *)applyMinGreyScaleFilter:(CIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CIMinimumComponent"];
    [filter setValue:image forKey:@"inputImage"];
    return [filter valueForKey:@"outputImage"];
}

- (CIImage *)applySharpenFilter:(CIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CISharpenLuminance"];
    [filter setValue:image forKey:@"inputImage"];
    return [filter valueForKey:@"outputImage"];
}

- (CIImage *)applyDesaturationFilter:(CIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:image forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:0.0] forKey:@"inputSaturation"];
    return [filter valueForKey:@"outputImage"];
}

- (CIImage *)applyMedianFilter:(CIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CIMedianFilter"];
    [filter setValue:image forKey:@"inputImage"];
    return [filter valueForKey:@"outputImage"];
}

- (CIImage *)applyPosterizeFilter:(CIImage *)image {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorPosterize"];
    [filter setValue:image forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputLevels"];
    return [filter valueForKey:@"outputImage"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)drawFaceFullScreen:(id)sender {
    // todo: initialize PaintPortraitViewController
    CGRect viewFrame;
    UIView *view = [self.faces objectAtIndex:self.pageControl.currentPage];

    for (UIView *subView in [view subviews]) {
        if ([subView isMemberOfClass:[FaceRect class]]) {
            
            viewFrame = faceRectInImage(subView.frame, view.frame.size, self.image.size);
            
            NSLog(@"viewFrame: %f %f %f %f", viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height);
            break;
        }
    }

    float scale = scaleFactor(self.image.size, CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT));
    CGRect imageRect = pixelFromPoint(viewFrame, scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.image CGImage], imageRect);
    
    CIImage *image = [CIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
        
    CIImage *touched1 = [self applySharpenFilter:[self applyDesaturationFilter:image]];
    CIImage *touched = [self applyPixellateFilter:touched1];
    CGImageRef result = [context createCGImage:touched fromRect:[touched extent]];
    
    [self renderQuartzImage:result];

}

- (IBAction)pickAnotherPhoto:(id)sender {
    
    PortraitViewController *viewController = (PortraitViewController *)self.presentingViewController;
    viewController.userPhoto = nil;
    viewController.didSelectPhoto = NO;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

}

- (void)renderQuartzImage:(CGImageRef)image {
     UIGraphicsBeginImageContextWithOptions(CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT), NO, 0);
     CGContextRef currentContext = UIGraphicsGetCurrentContext();
     
     CGContextSetInterpolationQuality(currentContext, kCGInterpolationHigh);
     CGContextTranslateCTM(currentContext, 0, IMAGE_HEIGHT);
     CGContextScaleCTM(currentContext, 1, -1);
     
     CGContextDrawImage(currentContext, CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT), image);
     UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();
    
     UIGraphicsEndImageContext();
 /*
     UIImageView *test = [[UIImageView alloc] initWithImage:anImage];
     test.contentMode = UIViewContentModeScaleAspectFit;
     test.frame = self.view.bounds;
     [self.view addSubview:test];
  */  
   // PaintPortraitViewController *viewController = [[PaintPortraitViewController alloc] initWithImage:anImage];
    PopPortraitViewController *viewController = [[PopPortraitViewController alloc] initWithImage:anImage];
    [self presentViewController:viewController animated:YES completion:nil];


}

- (IBAction)nextFace:(id)sender {
    //NSLog(@"%i, %@", self.pageControl.currentPage,[self.faces objectAtIndex:self.pageControl.currentPage]);
    [self.view bringSubviewToFront:[self.faces objectAtIndex:self.pageControl.currentPage]];
    
}

@end

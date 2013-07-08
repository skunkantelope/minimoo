//
//  PortraitFaceDefineViewController.m
//  Portrait
//
//  Created by Qian Wang on 7/6/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import "PortraitFaceDefineViewController.h"
#import "FaceRect.h"
#import "PaintPortraitViewController.h"

@interface PortraitFaceDefineViewController () {
    CIContext *context;
    CIDetector *detector;
    
}
@property (retain, nonatomic) UIImage *image; // store a reference to the album photo
@property (retain, nonatomic) NSMutableArray *faces; // store UIImageView

- (void)detectFaces;
//- (UIImage *)createFaceImage:(CGRect)rect;

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
    [self.view bringSubviewToFront:[self.faces objectAtIndex:0]];

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
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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

// Pixellate the resulting image.
- (UIImage *)createFaceImage:(CGRect)rect {
   // NSLog(@"feature bound %f %f %f %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    UIGraphicsBeginImageContextWithOptions(self.image.size, NO, 0);
   // NSLog(@"image size %f %f", self.image.size.width, self.image.size.height);
    
    [self.image drawInRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
    
 /*   CGContextRef cgContext = UIGraphicsGetCurrentContext();
    
    CGContextSetInterpolationQuality(cgContext, kCGInterpolationHigh);
    CGContextTranslateCTM(cgContext, 0, self.image.size.height);
    CGContextScaleCTM(cgContext, 1, -1);
    
    CGContextSetRGBFillColor(cgContext, 0.0, 0.0, 0.0, 0.5);
    CGContextSetStrokeColorWithColor(cgContext, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(cgContext, 10.0f);
    CGContextAddRect(cgContext, rect);
    CGContextDrawPath(cgContext, kCGPathFillStroke);
  */  
    
    UIImage * anImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return anImage;
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
            viewFrame = subView.frame;
        }
    }

    float scale = scaleFactor(self.image.size, CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT));
    CGRect imageRect = pixelFromPoint(viewFrame, scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.image CGImage], imageRect);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, 0);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(currentContext, kCGInterpolationHigh);
    
    CGContextDrawImage(currentContext, imageRect, imageRef);
    UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
 
    PaintPortraitViewController *viewController = [[PaintPortraitViewController alloc] initWithImage:anImage];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (IBAction)nextFace:(id)sender {
    NSLog(@"%i, %@", self.pageControl.currentPage,[self.faces objectAtIndex:self.pageControl.currentPage]);
    [self.view bringSubviewToFront:[self.faces objectAtIndex:self.pageControl.currentPage]];
    
}

@end

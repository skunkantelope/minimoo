//
//  PortraitFaceDefineViewController.m
//  Portrait
//
//  Created by Qian Wang on 7/6/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import "PortraitFaceDefineViewController.h"

@interface PortraitFaceDefineViewController () {
    CIContext *context;
    CIDetector *detector;
    
}
@property (retain, nonatomic) UIImage *image;
- (void)detectFaces;
//- (UIImage *)createFaceImage:(CGRect)rect;

@end

#define IMAGE_WIDTH 300

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

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // self.imageView.image = self.image;
    [self detectFaces];
}

- (void)detectFaces {
    // call CIImage property of UIImage does not work or provide a valid CIImage.
    CIImage *image = [CIImage imageWithCGImage:[self.image CGImage]];
 //     NSDictionary *opts = [NSDictionary dictionaryWithObject:[[image properties] valueForKey:(NSString*)kCGImagePropertyOrientation] forKey:CIDetectorImageOrientation];
    NSArray *features = [detector featuresInImage:image options:nil];
    
    NSLog(@"number of faces: %i", [features count]);
    // In case there are no faces detected, the scene goes back to the beginning scene.
    if ([features count] < 1) {
        // todo: animation to tell user to pick a photo with faces.
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
//    for (CIFaceFeature *feature in features) {
        // todo: transform the coordinates 
        // todo: draw the content bordered by feature, bitmap context. Each is an UIView. Use page control
   /*     float scale = IMAGE_WIDTH / feature.bounds.size.width;
        float IMAGE_HEIGHT = feature.bounds.size.height * scale;
        
        CGSize imageSize = CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT);
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
       
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
      
        CGContextSetInterpolationQuality(currentContext, kCGInterpolationHigh);
        
     //   CGContextTranslateCTM(currentContext, 0, feature.bounds.size.height);
     //   CGContextScaleCTM(currentContext, 1, -1);
        CGContextDrawImage(currentContext, CGRectIntegral(feature.bounds), [self.image CGImage]);
        
        UIImage *faceImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        self.imageView.image = faceImage;
    //    [faceImage drawInRect:self.imageView.bounds];
    */
    
 //   }
    CIFaceFeature *feature = [features objectAtIndex:0];
    NSLog(@"feature bound %f %f %f %f", feature.bounds.origin.x, feature.bounds.origin.y, feature.bounds.size.width, feature.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(self.image.size, NO, 0);
    NSLog(@"image size %f %f", self.image.size.width, self.image.size.height);
    
    [self.image drawInRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(cgContext, 0, self.image.size.height);
    CGContextScaleCTM(cgContext, 1, -1);
    
    CGContextSetRGBFillColor(cgContext, 0.0, 0.0, 0.0, 0.5);
    CGContextSetStrokeColorWithColor(cgContext, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(cgContext, 10.0f);
    CGContextAddRect(cgContext, feature.bounds);
    CGContextDrawPath(cgContext, kCGPathFillStroke);
    
    UIImage * anImage = UIGraphicsGetImageFromCurrentImageContext();
    
    self.imageView.image = anImage;
    
    UIGraphicsEndImageContext();
}
/*
- (UIImage *)createFaceImage:(CGRect)rect {
    
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextFace:(id)sender {
    
}
@end

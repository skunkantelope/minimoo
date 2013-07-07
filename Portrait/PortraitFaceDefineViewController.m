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

@end

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
    [self detectFaces];
}

- (void)detectFaces {
    // call CIImage property of UIImage does not work or provide a valid CIImage.
    CIImage *image = [CIImage imageWithCGImage:[self.image CGImage]];
    //  NSDictionary *opts = [NSDictionary dictionaryWithObject:[[image properties] valueForKey:(NSString*)kCGImagePropertyOrientation] forKey:CIDetectorImageOrientation];
    NSArray *features = [detector featuresInImage:image options:nil];
    
    NSLog(@"number of faces: %i", [features count]);
    for (CIFaceFeature *feature in features) {
        // todo: transform the coordinates 
        // todo: draw the content bordered by feature. Each is an UIView. Use page control
        CGRect frame = CGRectMake(feature.bounds.origin.x, feature.bounds.origin.y, feature.bounds.size.width, feature.bounds.size.height);
    //    FaceRect *rect = [[FaceRect alloc] initWithFrame:frame target:self];
    //    [self.view addSubview:rect];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

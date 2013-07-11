//
//  PopPortraitViewController.m
//  Portrait
//
//  Created by Qian Wang on 7/6/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import "PopPortraitViewController.h"

@interface PopPortraitViewController () {
    CGPoint lastPoint;
    BOOL drawPoint;
    CGColorRef currentColor;
}

@property (nonatomic, retain) UIImage* faceImage;

@end

@implementation PopPortraitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImage:(UIImage *)anImage {
    self = [super init];
    if (self) {
        self.faceImage = anImage;
    }
    return self;
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    drawPoint = YES;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    drawPoint = NO;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.faceImage.size);
    
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.faceImage.size.width, self.faceImage.size.height)];
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(cgContext, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(cgContext, currentPoint.x, currentPoint.y);
    CGContextSetLineCap(cgContext, kCGLineCapRound);
    CGContextSetLineWidth(cgContext, 20.0);
//    NSLog(@"stroke color %@", currentColor);
    CGContextSetStrokeColorWithColor(cgContext, currentColor);
    CGContextSetBlendMode(cgContext, kCGBlendModeMultiply);
    
    CGContextStrokePath(cgContext);
    
 //   self.drawingImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (drawPoint) {
        UIGraphicsBeginImageContext(self.faceImage.size);
        [self.imageView.image drawInRect:CGRectMake(0, 0, self.faceImage.size.width, self.faceImage.size.height)];
        
        CGContextRef cgContext = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(cgContext, lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(cgContext, lastPoint.x, lastPoint.y);
        CGContextSetLineCap(cgContext, kCGLineCapRound);
        CGContextSetLineWidth(cgContext, 20.0);
        CGContextSetStrokeColorWithColor(cgContext, currentColor);
        CGContextStrokePath(cgContext);
     //   CGContextFlush(cgContext);
        
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();        
    }
  /*  [UIView animateWithDuration:3 animations:^{
        [self.view bringSubviewToFront:self.drawingImage];
    }]; */
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageView.image = self.faceImage;
    Pallette *pallettePanel = [[Pallette alloc] initWithColor:[UIColor blueColor]];
    pallettePanel.delegate = self;
    pallettePanel.frame = CGRectMake(10, 10, 300, 40);
    
    [self.view addSubview:pallettePanel];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved."  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image has been saved"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)brushColor:(UIGestureRecognizer *)gestureRecognizer {
    
    UIColor *pickedColor = gestureRecognizer.view.backgroundColor;
 //   NSLog(@"color picked %@", pickedColor);
    currentColor = [pickedColor CGColor];
}

- (IBAction)mail:(id)sender {
}

- (IBAction)postTotwitter:(id)sender {
}

- (IBAction)saveToPhotos:(id)sender {
}
@end

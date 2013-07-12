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
@property (retain) Pallette *pallettePanel;

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

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self becomeFirstResponder];
    
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
    CGContextSetBlendMode(cgContext, kCGBlendModeNormal);
    CGContextSetLineCap(cgContext, kCGLineCapRound);
    CGContextSetLineWidth(cgContext, 5);
    CGContextSetStrokeColorWithColor(cgContext, currentColor);

    CGContextMoveToPoint(cgContext, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(cgContext, currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(cgContext);
    
 //   self.drawingImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (drawPoint) {
        // draw a rect
        CGRect dodgeRect = CGRectMake(lastPoint.x - 10, lastPoint.y - 10, 40, 20);
        UIGraphicsBeginImageContext(self.faceImage.size);
        [self.imageView.image drawInRect:CGRectMake(0, 0, self.faceImage.size.width, self.faceImage.size.height)];
        
        CGContextRef cgContext = UIGraphicsGetCurrentContext();
        CGContextSetBlendMode(cgContext, kCGBlendModeOverlay);
        CGContextSetAlpha(cgContext, 0.9);
        CGContextSetFillColorWithColor(cgContext, currentColor);
        
        CGContextFillRect(cgContext, dodgeRect);
        
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
    self.pallettePanel = [[Pallette alloc] initWithColor:[UIColor blueColor]];
    self.pallettePanel.delegate = self;
    self.pallettePanel.frame = CGRectMake(10, 10, 300, 40);
    
    [self.view addSubview:self.pallettePanel];
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

- (IBAction)goBackToFaceDefine:(id)sender {

    NSLog(@"I am called");
    self.pallettePanel.delegate = nil;
    [self.pallettePanel removeFromSuperview];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)mail:(id)sender {
}

- (IBAction)postTotwitter:(id)sender {
}

- (IBAction)saveToPhotos:(id)sender {
}

# pragma handling motion events
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
 
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"I am shaked");
        self.imageView.image = self.faceImage;
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
}

@end

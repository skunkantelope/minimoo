//
//  PopPortraitViewController.m
//  Portrait
//
//  Created by Qian Wang on 7/6/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import "PopPortraitViewController.h"
#import <Social/Social.h>

@interface PopPortraitViewController () {
    CGPoint lastPoint;
    BOOL drawPoint;
    CGColorRef currentColor;
    CALayer *strokeLayer;
    
}

@property (nonatomic, retain) UIImage* faceImage;
@property (retain) Pallette *pallettePanel;

- (void)brushSize:(CGRect) rect;

- (void)removeContextCue:(UIGestureRecognizer *)gestureRecognizer;

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
        currentColor = NULL;
        strokeLayer = nil;
    }
    return self;
    
}

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self becomeFirstResponder];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Shake" ofType:@"png"];
    UIImageView *contextCue = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeContextCue:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [contextCue addGestureRecognizer:tapGestureRecognizer];
    
    contextCue.frame = CGRectMake(284, 10, 36, 48);
    [self.view addSubview:contextCue];
 /*   [UIView animateWithDuration:7
                          delay:5
                        options:UIViewAnimationOptionRepeat
                     animations:^{
                         [self.view addSubview:contextCue];
                     }completion:nil
     ];*/
}

- (void)removeContextCue:(UIGestureRecognizer *)gestureRecognizer {
    [gestureRecognizer.view removeFromSuperview];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    drawPoint = YES;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    drawPoint = NO;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.imageView];
    
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
        CGRect rect = CGRectMake(lastPoint.x - 10, lastPoint.y - 10, 20, 20);
        CGRect dodgeRect = faceRectInImage(rect, CGSizeMake(300, 350), self.faceImage.size);
      //  CGRect dodgeRect = faceRectInImage(rect, CGSizeMake(300, 350), self.faceImage.size);
        
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
    if (error) {
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

    CGRect brushStroke = CGRectMake(10, 50, 30, 30);
    [self brushSize:brushStroke];
}

- (void)brushSize:(CGRect) rect {
    CALayer *layer = [CALayer layer];
    layer.opacity = 0.6;
    layer.backgroundColor = currentColor;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.4;
    layer.shadowRadius = 2;
    layer.shadowOffset = CGSizeMake(2,2);
    layer.frame = rect;
    
    if (strokeLayer) {
        [strokeLayer removeFromSuperlayer];
    }
    strokeLayer = layer;
    [self.view.layer addSublayer:layer];
}

- (IBAction)goBackToFaceDefine:(id)sender {

    NSLog(@"I am called");
    self.pallettePanel.delegate = nil;
    [self.pallettePanel removeFromSuperview];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postTotwitter:(id)sender {
    
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"This is a painting that I did with Pop Art Portrait."];
    [tweetSheet addImage:self.imageView.image];
    [self presentViewController:tweetSheet animated:YES completion:nil];

}

- (IBAction)postToFacebook:(id)sender {
        
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:@"This is a painting that I did with Pop Art Portrait"];
        [facebookSheet addImage:self.imageView.image];
        [self presentViewController:facebookSheet animated:YES completion:nil];


}

- (IBAction)postToWeibo:(id)sender {
        
        SLComposeViewController *weiboSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        [weiboSheet setInitialText:@"This is a painting that I did with Pop Art Portrait"];
        [weiboSheet addImage:self.imageView.image];
        [self presentViewController:weiboSheet animated:YES completion:nil];


}

- (IBAction)saveToPhotos:(id)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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

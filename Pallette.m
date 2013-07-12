//
//  Pallette.m
//  Portrait
//
//  Created by Qian Wang on 7/10/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import "Pallette.h"

#define kColor 6
//#define ARC4RANDOM_MAX 0x100000000

@implementation Pallette 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithColor:(UIColor *)hue {
    self = [super init];
    if (self) {
        
        float chroma;
        float saturation;
        float brightness;
        float alpha;
        [hue getHue:&chroma saturation:&saturation brightness:&brightness alpha:&alpha];
        
        //UIColor *white = [UIColor whiteColor];
        //UIColor *red = [UIColor colorWithHue:0.0 saturation:1.0 brightness:0.7 alpha:0.8];
        UIColor *fuschia = [UIColor colorWithRed:209.0/255.0f green:11.0/255.0f blue:187.0/255.0f alpha:0.8];
        UIColor *complementary = [UIColor colorWithHue:0.8 - chroma saturation:saturation brightness:brightness alpha:1.0];
        UIColor *highlight = [UIColor colorWithHue:chroma saturation:0.1 brightness:1.0 alpha:1.0];
        UIColor *light = [UIColor colorWithHue:chroma saturation:0.3 brightness:0.9 alpha:1.0];
        UIColor *dark = [UIColor colorWithHue:chroma saturation:1.0 brightness:0.7 alpha:1.0];
        UIColor *shadow = [UIColor colorWithHue:chroma saturation:1.0 brightness:0.3 alpha:1.0];
        
        NSArray *colors = @[complementary, fuschia, highlight, light, dark, shadow];
        
        float xOffset = 30.0;
        float width = 40.0;
        
        for (int i = 0; i < kColor; ++i) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xOffset + width * i, 0, 40, 40)];
    //        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(brushColor:)];
    //        tapGestureRecognizer.numberOfTapsRequired = 1;
    //        [view addGestureRecognizer:tapGestureRecognizer];
            
            view.backgroundColor = [colors objectAtIndex:i];
            
            [self addSubview:view];
        }
        
      //  self.backgroundColor = [UIColor lightGrayColor];
    }
    return  self;    
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    for (UIView *view in [self subviews]) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(brushColor:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [view addGestureRecognizer:tapGestureRecognizer];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

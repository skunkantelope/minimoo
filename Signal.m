//
//  Signal.m
//  Portrait
//
//  Created by Qian Wang on 7/15/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import "Signal.h"

@implementation Signal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetCMYKFillColor(context, 91, 74, 9, 1, 1);
    CGContextSetCMYKStrokeColor(context, 51, 74, 0, 0, 1);
    CGContextSetLineWidth(context, 2);

    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    CGContextFillPath(context);
    
    
}

@end

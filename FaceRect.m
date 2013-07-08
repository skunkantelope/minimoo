//
//  FaceRect.m
//  Portrait
//
//  Created by Qian Wang on 3/26/13.
//  Copyright (c) 2013 Pony Studio. All rights reserved.
//

#import "FaceRect.h"

@implementation FaceRect {
    BOOL adjustUpperBound;
    BOOL adjustLowerBound;
    BOOL adjustLeftBound;
    BOOL adjustRightBound;
    
}

#define TOUCH_RADIUS 10
#define TRANSLATION_TOLERANCE 5

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        adjustLeftBound = FALSE;
        adjustLowerBound = FALSE;
        adjustRightBound = FALSE;
        adjustUpperBound = FALSE;
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        
       
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Use the coordinates of super view.
    float w = self.bounds.size.width;
    float h = self.bounds.size.height;
    
    CGPoint location = [[touches anyObject] locationInView:self.superview];
    //  NSLog(@"touch %f %f", location.x, location.y);
    
    // adjust upper bound
    if (self.frame.origin.x < location.x < self.frame.origin.x + w && fabsf(location.y - self.frame.origin.y) <= TOUCH_RADIUS) {
        adjustUpperBound = TRUE;
        adjustRightBound = FALSE;
        adjustLowerBound = FALSE;
        adjustLeftBound = FALSE;
        
        return;
    }
    // adjust lower bound
    if (self.frame.origin.x < location.x < self.frame.origin.x + w && fabsf(location.y - self.frame.origin.y - h) <= TOUCH_RADIUS) {
        adjustLowerBound = TRUE;
        adjustRightBound = FALSE;
        adjustUpperBound = FALSE;
        adjustLeftBound = FALSE;
        
        return;
    }
    // adjust left bound
    if (self.frame.origin.y < location.y < self.frame.origin.y + h && fabsf(location.x - self.frame.origin.x) <= TOUCH_RADIUS) {
        adjustLeftBound = TRUE;
        adjustLowerBound = FALSE;
        adjustRightBound = FALSE;
        adjustUpperBound = FALSE;
        
        return;
    }
    // adjust right bound
    if (self.frame.origin.y < location.y < self.frame.origin.y + h && fabsf(location.x - self.frame.origin.x - w) <= TOUCH_RADIUS) {
        adjustRightBound = TRUE;
        adjustUpperBound = FALSE;
        adjustLowerBound = FALSE;
        adjustLeftBound = FALSE;
        
        return;
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *firstTouch = [touches anyObject];
    CGPoint touchTo = [firstTouch locationInView:self.superview];
    CGPoint touchFrom = [firstTouch previousLocationInView:self.superview];
    //  NSLog(@"to %f %f", touchTo.x, touchTo.y);
    //  NSLog(@"from %f %f", touchFrom.x, touchFrom.y);
    //  NSLog(@"frame %f %f", self.frame.origin.x, self.frame.origin.y);
    
    float dx = touchTo.x - touchFrom.x;
    float dy = touchTo.y - touchFrom.y;
    
    if (adjustUpperBound) {
        if (fabsf(dx) <= TRANSLATION_TOLERANCE) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + dy, self.frame.size.width, self.frame.size.height - dy);
            //[self setNeedsDisplay];
        }
        return;
    }
    
    if (adjustLowerBound) {
        if (fabsf(dx) <= TRANSLATION_TOLERANCE) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + dy);
            //[self setNeedsDisplay];
        }
        return;
    }
    
    if (adjustLeftBound) {
        if (fabsf(dy) <= TRANSLATION_TOLERANCE) {
            self.frame = CGRectMake(self.frame.origin.x + dx, self.frame.origin.y, self.frame.size.width - dx, self.frame.size.height);
            //[self setNeedsDisplay];
        }
        return;
    }
    
    if (adjustRightBound) {
        if (fabsf(dy) <= TRANSLATION_TOLERANCE) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width + dx, self.frame.size.height);
            //[self setNeedsDisplay];
        }
        
        return;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    adjustLowerBound = FALSE;
    adjustRightBound = FALSE;
    adjustLeftBound = FALSE;
    adjustUpperBound = FALSE;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.transform = CGAffineTransformIdentity;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{     
    // Drawing code
 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    const float strokeColorComponents[4] = {1.0, 1.0, 1.0, 0.8};
   
    CGColorRef strokeColor = CGColorCreate(colorSpace, strokeColorComponents);
    
    self.layer.borderColor = strokeColor;
    self.layer.borderWidth = 10;
    
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(strokeColor);
    
}

@end

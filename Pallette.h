//
//  Pallette.h
//  Portrait
//
//  Created by Qian Wang on 7/10/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

@protocol PalletteDelegate <NSObject>

- (void)brushColor:(UIGestureRecognizer *)gestureRecognizer;

@end

@interface Pallette : UIView
    
@property (assign) id<PalletteDelegate> delegate;


- (id)initWithColor:(UIColor *)hue;

@end

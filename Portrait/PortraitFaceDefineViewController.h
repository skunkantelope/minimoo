//
//  PortraitFaceDefineViewController.h
//  Portrait
//
//  Created by Qian Wang on 7/6/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortraitFaceDefineViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (id)initWithImage:(UIImage *)image;

@end

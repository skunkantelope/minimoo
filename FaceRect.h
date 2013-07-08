//
//  FaceRect.h
//  Portrait
//
//  Created by Qian Wang on 3/26/13.
//  Copyright (c) 2013 Pony Studio. All rights reserved.
//

@interface FaceRect : UIView

// target implement zoomInOnFrame method or use delegate design. 
- (id) initWithFrame:(CGRect)frame target:(id)object;

@end

//
//  CoordinateSystemConversion.h
//  Portrait
//
//  Created by Qian Wang on 7/8/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

float scaleFactor(CGSize imageSize, CGSize viewSize);
CGRect pointFromPixel(CGRect rect, float scale);
CGRect pixelFromPoint(CGRect rect, float scale);

CGRect userCoordinateFromGraphicsCoordinate(CGRect rect, CGSize imageSize);

CGRect faceRectInImage(CGRect faceRect, CGSize view, CGSize image);
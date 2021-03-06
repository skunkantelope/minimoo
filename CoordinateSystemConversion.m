//
//  CoordinateSystemConversion.m
//  Portrait
//
//  Created by Qian Wang on 7/8/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#include "CoordinateSystemConversion.h"

float scaleFactor(CGSize imageSize, CGSize viewSize) {
    if (imageSize.width >= imageSize.height) {
        return viewSize.width/imageSize.width;
    } else {
        return viewSize.height/imageSize.height;
    }
}

CGRect userCoordinateFromGraphicsCoordinate(CGRect rect, CGSize imageSize) {
    return CGRectMake(rect.origin.x, -rect.origin.y + imageSize.height, rect.size.width, rect.size.height);
}

CGRect pointFromPixel(CGRect rect, float scale) {

    return CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
}

// scale is from scaleFactor function. use its reciprocal here. rect is the frame of the view
CGRect pixelFromPoint(CGRect rect, float scale) {
    return CGRectMake(rect.origin.x / scale, rect.origin.y / scale, rect.size.width / scale, rect.size.height / scale);
}

// image is the original non-scaled image.
CGRect faceRectInImage(CGRect faceRect, CGSize view, CGSize image) {
    float dx, dy;
    
    if (image.width >= image.height) {
        
        float imageHeight = view.width/image.width * image.height;
        dx = 0;
        dy = (view.height - imageHeight) / 2.0;
    } else {
        float imageWidth = view.height/image.height * image.width;
        dx = (view.width - imageWidth) / 2.0;
        dy = 0;
    }

    return CGRectMake(faceRect.origin.x - dx, faceRect.origin.y - dy, faceRect.size.width, faceRect.size.height);
}
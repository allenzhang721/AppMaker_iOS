//
//  ViewCrop.m
//  MoueeReleaseVertical
//
//  Created by user on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ViewCrop.h"

@implementation ViewCrop

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(UIImage *) crop:(UIView *) view :(CGRect) rect
{
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContext(size);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

//
//  CSSlider.m
//  slider_DEMO
//
//  Created by 星宇陈 on 13-12-17.
//  Copyright (c) 2013年 星宇陈. All rights reserved.
//

#import "CSSlider.h"

@implementation CSSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
//{
//    float max = self.maximumValue;
//    float unit = (rect.size.width - 11) / max *1.0;
//    return CGRectMake(unit * value - 4 , bounds.size.height/2 - 11, 22, 22);
//}

@end

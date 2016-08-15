//
//  MoueeSlideScrollView.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-9-13.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLSlideScrollView.h"

@implementation HLSlideScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([_cancelDelegate respondsToSelector:@selector(touchesShouldCancelInView:)]) {
        return [_cancelDelegate touchesShouldCancelInView:view];
    }else {
        return YES;
    }
}

@end

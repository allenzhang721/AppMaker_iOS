//
//  ClearScrollView.m
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 13-12-31.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLClearScrollView.h"

@implementation HLClearScrollView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL isAction = NO;
    for (UIView *subView in self.subviews)
    {
        CGPoint temp = [subView convertPoint:point fromView:self];
        if ([subView pointInside:temp withEvent:event])
        {
            if (subView.hidden == NO)
            {
                isAction = YES;
            }
        }
    }
    return isAction;
}

@end

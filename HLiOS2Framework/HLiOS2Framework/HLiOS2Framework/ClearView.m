//
//  ClearView.m
//  MoueeIOS2Core
//
//  Created by Allen on 12-12-1.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "ClearView.h"

@implementation ClearView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *sub in self.subviews)
    {
        CGPoint tmp = [sub convertPoint:point fromView:self];
        
        if ([sub pointInside:tmp withEvent:event])
        {
            return YES;
        }
    }
    if (self.delegate != nil)
    {
        [self.delegate onTouchInside:point withEvent:event];
    }
    return NO;
}

@end

//
//  UIView+ClearView.m
//  MoueeIOS2Core
//
//  Created by Allen on 12-12-1.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "UIView+ClearView.h"

@implementation UIView (ClearView)
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
    return NO;
}
@end

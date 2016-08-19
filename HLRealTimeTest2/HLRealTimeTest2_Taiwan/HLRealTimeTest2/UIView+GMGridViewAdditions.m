//
//  UIView+GMGridViewShake.m
//  GMGridView
//
//  Created by Gulam Moledina on 11-10-22.
//  Copyright (c) 2011 GMoledina.ca. All rights reserved.
//
//  Latest code can be found on GitHub: https://github.com/gmoledina/GMGridView
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+GMGridViewAdditions.h"

@interface UIView (GMGridViewAdditions_Privates)


@end




@implementation UIView (GMGridViewAdditions)

- (void)shakeStatus:(BOOL)enabled
{
    if (enabled) 
    {
        //CGFloat rotation = 0.03;
        
        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shake.duration = 0.3;
        shake.autoreverses = NO;
        shake.repeatCount  = 0;
        shake.removedOnCompletion = NO;
        [shake setFillMode:kCAFillModeForwards];
        shake.fromValue = [NSNumber numberWithFloat:1.0];
        shake.toValue   = [NSNumber numberWithFloat:1.1];
        
        [self.layer addAnimation:shake forKey:@"shakeAnimation"];
    }
    else
    {
        [self.layer removeAnimationForKey:@"shakeAnimation"];
        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shake.duration = 0.3;
        shake.autoreverses = NO;
        shake.repeatCount  = 0;
        shake.removedOnCompletion = YES;
        shake.fromValue = [NSNumber numberWithFloat:1.1];
        shake.toValue   = [NSNumber numberWithFloat:1.0];
        
        [self.layer addAnimation:shake forKey:@"shakeAnimation"];
    }
}

@end
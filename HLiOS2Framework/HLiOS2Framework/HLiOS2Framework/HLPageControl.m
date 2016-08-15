//
//  MoueePageControl.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-22.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLPageControl.h"

#define kPageControlSize 12
#define kPagePointSpace  20

@implementation HLPageControl

- (id)initWithFrame:(CGRect)frame pageCount:(int)pageCount isHorizon:(BOOL)isHorizon
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _count = pageCount;
        
        float width = kPagePointSpace * pageCount - (kPagePointSpace - kPageControlSize);
        float left = (frame.size.width - width) / 2.0;
        float top = 0;
        
        UIButton *leftArea = [UIButton buttonWithType:UIButtonTypeCustom];
        leftArea.frame = CGRectMake(0, 0, self.frame.size.width / 2.0, self.frame.size.height);
        [leftArea addTarget: self action:@selector(leftAreaClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftArea];
        
        UIButton *rightArea = [UIButton buttonWithType:UIButtonTypeCustom];
        rightArea.frame = CGRectMake(self.frame.size.width / 2.0, 0, self.frame.size.width / 2.0, self.frame.size.height);
        [rightArea addTarget: self action:@selector(rightAreaClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightArea];
        
        if (!isHorizon)
        {
            float height = width;
            top = (frame.size.height - height) / 2.0;
            leftArea.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 2.0);
            rightArea.frame = CGRectMake(0, self.frame.size.height / 2.0, self.frame.size.width, self.frame.size.height / 2.0);
        }
        
        for (int i = 0; i < pageCount; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            [button addTarget:self action:@selector(pageControlValueChange:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"PageControlUnSelectedImg.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"PageControlSelectedImg.png"] forState:UIControlStateSelected];
            if (isHorizon)
            {
                button.frame = CGRectMake(left + kPagePointSpace * i, 6, kPageControlSize, kPageControlSize);
            }
            else
            {
                button.frame = CGRectMake(6, top + kPagePointSpace * i, kPageControlSize, kPageControlSize);
            }
            
            button.adjustsImageWhenHighlighted = NO;
            [self addSubview:button];
        }
        
        [self setCurIndex:0];

    }
    return self;
}

- (void)setCurIndex:(int)index
{
    _curIndex = [self checkIndex:index];
    for (UIButton *btn in self.subviews)
    {
        if ([btn isKindOfClass:[UIButton class]])
        {
            if (btn.tag == index)
            {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    if ([_deleage respondsToSelector:@selector(pageControlValueChange:)])
    {
        [_deleage pageControlValueChange:index];
    }
}

- (void)pageControlValueChange:(UIButton *)sender
{
    [self setCurIndex:sender.tag];
}

- (void)leftAreaClicked
{
    [self setCurIndex:[self checkIndex:_curIndex - 1]];
}

- (void)rightAreaClicked
{
    [self setCurIndex:[self checkIndex:_curIndex + 1]];
}

- (int)checkIndex:(int)index
{
    int curIndex = index;
    if (index >= _count)
    {
        curIndex = _count - 1;
    }
    else if (index < 0)
    {
        curIndex = 0;
    }
    return curIndex;
}

@end

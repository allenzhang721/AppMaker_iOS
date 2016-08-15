//
//  RootSliderScrollView.m
//  TheBeijingNews
//
//  Created by 清软 时代 on 12-11-13.
//  Copyright (c) 2012年 清软 时代. All rights reserved.
//

#import "RootSliderScrollView.h"

@implementation RootSliderScrollView

@synthesize loopDelegate = _loopDelegate;
@synthesize isVertical = _isVertical;
@synthesize isCanClicked = _isCanClicked;
@synthesize loopContentHeight = _loopContentHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = NO;
        _isVertical = NO;
        _isCanClicked = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        _loopContentHeight = 0;
        _lastHeight = 0;
//        self.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return self;
}

- (void)initViewContent:(NSArray *)imageArray path:(NSString *)path
{
    for (int i = 0; i < imageArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (!_isCanClicked)
        {
            button.userInteractionEnabled = NO;
        }
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", path, [imageArray objectAtIndex:i]]];
        button.contentMode = UIViewContentModeScaleAspectFill;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.tag = i;

        button.frame = CGRectMake(0, _loopContentHeight, self.frame.size.width, self.frame.size.width * (image.size.height / image.size.width));
        _loopContentHeight += button.frame.size.height;
        
        button.adjustsImageWhenHighlighted = NO;
        [self addSubview:button];
    }
    
    if (imageArray.count > 1)//循环重用部分的图片
    {
        for (int i = 0; i < imageArray.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.contentMode = UIViewContentModeScaleAspectFill;
            [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (!_isCanClicked)
            {
                button.userInteractionEnabled = NO;
            }
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", path, [imageArray objectAtIndex:i]]];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            button.tag = i;
            
            button.frame = CGRectMake(0, _loopContentHeight + _lastHeight, self.frame.size.width, self.frame.size.width * (image.size.height / image.size.width));
            _lastHeight += button.frame.size.height;
            button.adjustsImageWhenHighlighted = NO;
            [self addSubview:button];
            if (_lastHeight > self.frame.size.height)
            {
                break;
            }
        }
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, _loopContentHeight + _lastHeight);

    [self setContentOffset:CGPointMake(0, 0)];
}

- (void)btnClicked:(UIButton *)sender
{
    if ([_loopDelegate respondsToSelector:@selector(clickedAtIndex: loopSliderScrollView:)])
    {
        [_loopDelegate clickedAtIndex:sender.tag loopSliderScrollView:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float offset = 0;
    offset = self.contentOffset.y;
    NSLog(@"%f",offset);
    if (offset > self.contentSize.height - self.frame.size.height)
    {
        [self setContentOffset:CGPointMake(0, offset - _loopContentHeight)];
    }
    if (offset < 0)
    {
        [self setContentOffset:CGPointMake(0, _loopContentHeight)];
    }
}


//释放所有资源（释放内存）
- (void)unloadData
{
    for (UIButton *btn in self.subviews)
    {
        if ([btn isKindOfClass:[UIButton class]])
        {
            [btn setImage:nil forState:UIControlStateNormal];
        }
    }
}

@end

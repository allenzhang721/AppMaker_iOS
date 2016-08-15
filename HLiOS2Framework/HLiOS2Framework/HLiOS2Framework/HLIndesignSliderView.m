//
//  IndesignSliderView.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-14.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLIndesignSliderView.h"

@interface HLIndesignSliderView ()
{
    UIButton *_panBtn;
    UISlider *_slider;
    
    int _startX;
    int _endX;
    
    BOOL _isMoving;
}

@end

@implementation HLIndesignSliderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _startX = 10;
        _endX = frame.size.width - 10;
        
        _slider = [[[UISlider alloc] initWithFrame:CGRectMake(10, 13, frame.size.width - 20, 22)] autorelease];
        [_slider addTarget:self action:@selector(lightChanged) forControlEvents:UIControlEventValueChanged];
        
        _slider.backgroundColor = [UIColor clearColor];
        [_slider setMinimumTrackTintColor:[UIColor clearColor]];
        [_slider setMaximumTrackTintColor:[UIColor clearColor]];
        
        
        UIImage *minImage = [[UIImage imageNamed:@"Indesign_SliderBarClearBg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
        UIImage *maxImage = [[UIImage imageNamed:@"Indesign_SliderBarClearBg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
        [_slider setMinimumTrackImage:minImage forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
        
        [_slider setThumbImage:[UIImage imageNamed:@"Indesign_BottonNavSliderBtnUp.png"]  forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"Indesign_BottonNavSliderBtnDown.png"] forState:UIControlStateHighlighted];
        [_slider setValue:0];
        [self addSubview:_slider];

    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        _slider.frame = CGRectMake(10, 7, frame.size.width - 20, 22);
    }
    else
    {
        _slider.frame = CGRectMake(10, 13, frame.size.width - 20, 22);
    }
    
    _endX = frame.size.width - 10;
}


- (void)lightChanged
{
    if ([_delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [_delegate sliderValueChanged:_slider.value];
    }
}

- (void)setSliderValue:(float)value animated:(BOOL)animated
{
    if (value > 1)
    {
        value = 1;
    }
    if (value < 0)
    {
        value = 0;
    }
    float interval = 0;
    if (animated) {
        interval = .2;
    }
    [UIView animateWithDuration:interval animations:^{
//        _panBtn.frame = CGRectMake(_startX + (self.frame.size.width - _startX * 2 - _panBtn.frame.size.width) * value, _panBtn.frame.origin.y, _panBtn.frame.size.width, _panBtn.frame.size.height);
        _slider.value = value;
    }];
}


@end

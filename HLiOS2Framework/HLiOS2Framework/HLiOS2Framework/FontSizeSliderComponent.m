//
//  FontSizeSliderComponent.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-6-21.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "FontSizeSliderComponent.h"

@implementation FontSizeSliderComponent

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.fontSizeEntity = (FontSizeSliderEntity *)entity;
        slider = [[UISlider alloc] init];//WithFrame:CGRectMake(100, 130, 200, 22)
        [slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
        
//        slider.backgroundColor = [UIColor clearColor];
//        [slider setMinimumTrackTintColor:[UIColor clearColor]];
//        [slider setMaximumTrackTintColor:[UIColor clearColor]];
        
        
//        UIImage *minImage = [[UIImage imageNamed:@"Indesign_SliderBarClearBg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
//        UIImage *maxImage = [[UIImage imageNamed:@"Indesign_SliderBarClearBg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
//        [slider setMinimumTrackImage:minImage forState:UIControlStateNormal];
//        [slider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
        
//        [slider setThumbImage:[UIImage imageNamed:@"Indesign_BottonNavSliderBtnUp.png"]  forState:UIControlStateNormal];
//        [slider setThumbImage:[UIImage imageNamed:@"Indesign_BottonNavSliderBtnDown.png"] forState:UIControlStateHighlighted];
        [slider setMaximumValue:self.fontSizeEntity.maxFontSize];
        [slider setMinimumValue:self.fontSizeEntity.minFontSize];
        [slider setValue:self.fontSizeEntity.curFontSize];
        self.uicomponent = slider;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
    }
    return self;
}

- (void)sliderChanged
{
    int size = slider.value;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FontSizeChangeFromSlider" object:[NSNumber numberWithInt:size]];
}

- (void)dealloc
{
    [slider release];
    [super dealloc];
}

@end

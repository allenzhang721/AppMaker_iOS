//
//  IndesignSliderView.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-14.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderViewDelegate <NSObject>

- (void)sliderValueChanged:(float)value;

@end

@interface HLIndesignSliderView : UIView

@property (nonatomic, assign) id<SliderViewDelegate> delegate;

- (void)setSliderValue:(float)value animated:(BOOL)animated;

@end

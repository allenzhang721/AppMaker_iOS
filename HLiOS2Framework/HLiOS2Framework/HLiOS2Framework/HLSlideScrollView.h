//
//  MoueeSlideScrollView.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-9-13.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HLSlideScrollViewDelegate <NSObject>

- (BOOL)touchesShouldCancelInView:(UIView *)view;

@end

@interface HLSlideScrollView : UIScrollView

@property (nonatomic, assign) id<HLSlideScrollViewDelegate> cancelDelegate;

@end

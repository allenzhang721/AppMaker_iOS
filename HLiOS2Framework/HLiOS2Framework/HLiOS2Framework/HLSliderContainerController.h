//
//  SliderContainerController.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-6-25.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//  页间滑动

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HLSliderPageController.h"

//typedef enum AnimationEndPos
//{
//    LeftToCenter,
//    CenterToRight,
//    RightToCenter,
//    CenterToLeft
//}AnimationEndPos;

@class HLSliderPageController;

@interface HLSliderContainerController : NSObject
{
    float lastOffsetX;
    float curOffsetX;
}

@property BOOL isInitPos;
@property float scrollSpace;
@property float beginDragX;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic,assign) HLSliderPageController *page1Controller;
@property (nonatomic,assign) HLSliderPageController *page2Controller;
@property (nonatomic,assign) HLSliderPageController *page3Controller;
@property (nonatomic,assign) HLSliderPageController *curPageController;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView; 

@end

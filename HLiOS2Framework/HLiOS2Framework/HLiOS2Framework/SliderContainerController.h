//
//  SliderContainerController.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-6-25.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//  页间滑动

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SliderPageController.h"

//typedef enum AnimationEndPos
//{
//    LeftToCenter,
//    CenterToRight,
//    RightToCenter,
//    CenterToLeft
//}AnimationEndPos;

@class SliderPageController;

@interface SliderContainerController : NSObject
{
    float lastOffsetX;
    float curOffsetX;
}

@property BOOL isInitPos;
@property float scrollSpace;
@property float beginDragX;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic,assign) SliderPageController *page1Controller;
@property (nonatomic,assign) SliderPageController *page2Controller;
@property (nonatomic,assign) SliderPageController *page3Controller;
@property (nonatomic,assign) SliderPageController *curPageController;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView; 

@end

//
//  SliderPageContainerController.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-9.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//  页内滑动

#import "HLPageController.h"

typedef enum AnimationEndPos
{
    LeftToCenter,
    CenterToRight,
    RightToCenter,
    CenterToLeft
}AnimationEndPos;

@interface HLSliderPageContainerController : NSObject
{
    float lastOffsetY;
    float curOffsetY;
}

@property BOOL isInitPos;
@property float scrollSpace;
@property float beginDragY;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic,assign) HLPageController *page1Controller;
@property (nonatomic,assign) HLPageController *page2Controller;
@property (nonatomic,assign) HLPageController *page3Controller;
@property (nonatomic,assign) HLPageController *curPageController;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

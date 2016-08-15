//
//  SliderPageContainerController.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-9.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//  页内滑动

#import "PageController.h"

typedef enum AnimationEndPos
{
    LeftToCenter,
    CenterToRight,
    RightToCenter,
    CenterToLeft
}AnimationEndPos;

@interface SliderPageContainerController : NSObject
{
    float lastOffsetY;
    float curOffsetY;
}

@property BOOL isInitPos;
@property float scrollSpace;
@property float beginDragY;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic,assign) PageController *page1Controller;
@property (nonatomic,assign) PageController *page2Controller;
@property (nonatomic,assign) PageController *page3Controller;
@property (nonatomic,assign) PageController *curPageController;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

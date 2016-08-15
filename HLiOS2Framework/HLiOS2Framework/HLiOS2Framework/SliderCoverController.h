//
//  SliderCoverController.h
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 13-12-31.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "CoverBaseController.h"
#import "PageController.h"
#import "PageEntity.h"
#import "SliderCoverContainerController.h"
#import "SliderCoverPageController.h"

@class SliderCoverContainerController;
@class SliderFlipController;



@interface SliderCoverController : CoverBaseController
{
    ClearScrollView *clearScrollView;
    SliderFlipController *sliderFlipController;
    SliderCoverContainerController *containerController;
}

@property (nonatomic , assign) SliderCoverPageController *page1Controller;
@property (nonatomic , assign) SliderCoverPageController *page2Controller;
@property (nonatomic , assign) SliderCoverPageController *page3Controller;
@property (nonatomic , assign) SliderCoverPageController *currentPageController;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndGoToPage:(UIScrollView *)scrollView;
- (void)scrollViewBeginGoToPage:(UIScrollView *)scrollView;
@end

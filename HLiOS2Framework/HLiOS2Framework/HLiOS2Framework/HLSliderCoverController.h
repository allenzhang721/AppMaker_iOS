//
//  SliderCoverController.h
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 13-12-31.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLCoverBaseController.h"
#import "HLPageController.h"
#import "HLPageEntity.h"
#import "HLSliderCoverContainerController.h"
#import "HLSliderCoverPageController.h"

@class HLSliderCoverContainerController;
@class HLSliderFlipController;



@interface HLSliderCoverController : HLCoverBaseController
{
    HLClearScrollView *clearScrollView;
    HLSliderFlipController *sliderFlipController;
    HLSliderCoverContainerController *containerController;
}

@property (nonatomic , assign) HLSliderCoverPageController *page1Controller;
@property (nonatomic , assign) HLSliderCoverPageController *page2Controller;
@property (nonatomic , assign) HLSliderCoverPageController *page3Controller;
@property (nonatomic , assign) HLSliderCoverPageController *currentPageController;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndGoToPage:(UIScrollView *)scrollView;
- (void)scrollViewBeginGoToPage:(UIScrollView *)scrollView;
@end

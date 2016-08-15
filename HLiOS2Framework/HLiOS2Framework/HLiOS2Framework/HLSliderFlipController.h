//
//  SliderFlipController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-12-31.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLFlipBaseController.h"
#import "HLSliderPageController.h"
#import "HLSliderContainerController.h"
#import "HLSliderCoverController.h"

//      >>>>>
typedef enum {
    
    CoverDirectionLeft = 0,
    CoverDirectionRight
    
} CoverDirection;
//      <<<<<

@class HLSliderContainerController;
@class HLSliderPageController;

@interface HLSliderFlipController : HLFlipBaseController<UIScrollViewDelegate>
{
    BOOL _isGoBack;
    BOOL _isAutoPlay;
    HLSliderContainerController *sliderContainerController;
    
    //    >>>>> 1.3,publicCover
    BOOL changeRightCover;
    BOOL changeLeftCover;
    BOOL endDecelerate;
    BOOL isGotoPage;
    CGPoint currentLeftBound;
    CGPoint currentrightBound;
    //    <<<<<
    
    //  >>>>> check Pay
    BOOL shouldScrollRight;
    BOOL shouldScrollLeft;
    //
    
}


@property (nonatomic,retain) HLSliderPageController *page1Controller;
@property (nonatomic,retain) HLSliderPageController *page2Controller;
@property (nonatomic,retain) HLSliderPageController *page3Controller;
@property (nonatomic,retain) NSMutableArray       *goBackArray;
@property (nonatomic,assign) HLSliderPageController *currentPageController;
@property (nonatomic,retain) UIScrollView         *scrollView;
@property Boolean isWithGotoSubPage;
@property Boolean isWithSectionChange;
@property Boolean canScroll;
@property (nonatomic,retain) NSString* subpageid;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

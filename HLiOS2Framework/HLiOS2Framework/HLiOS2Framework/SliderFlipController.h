//
//  SliderFlipController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-12-31.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "FlipBaseController.h"
#import "SliderPageController.h"
#import "SliderContainerController.h"
#import "SliderCoverController.h"

//      >>>>>
typedef enum {
    
    CoverDirectionLeft = 0,
    CoverDirectionRight
    
} CoverDirection;
//      <<<<<

@class SliderContainerController;
@class SliderPageController;

@interface SliderFlipController : FlipBaseController<UIScrollViewDelegate>
{
    BOOL _isGoBack;
    BOOL _isAutoPlay;
    SliderContainerController *sliderContainerController;
    
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


@property (nonatomic,retain) SliderPageController *page1Controller;
@property (nonatomic,retain) SliderPageController *page2Controller;
@property (nonatomic,retain) SliderPageController *page3Controller;
@property (nonatomic,retain) NSMutableArray       *goBackArray;
@property (nonatomic,assign) SliderPageController *currentPageController;
@property (nonatomic,retain) UIScrollView         *scrollView;
@property Boolean isWithGotoSubPage;
@property Boolean isWithSectionChange;
@property Boolean canScroll;
@property (nonatomic,retain) NSString* subpageid;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

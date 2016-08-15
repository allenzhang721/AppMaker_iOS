//
//  SliderPageController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-12-31.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLPageController.h"
#import "HLPageEntity.h"
#import "HLSliderFlipController.h"
#import "HLSliderPageContainerController.h"
#import "HLSliderCoverPageController.h"
#import "HLEnumConstant.h"

@class HLSliderFlipController;

@interface HLSliderPageController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    HLSliderPageContainerController *sliderContainerController;
    
    
    //    >>>>> 1.3,publicCover
    BOOL changeUpCover;
    BOOL changeDownCover;
    BOOL endDecelerate;
    BOOL isGotoPage;
    CGPoint currentUpBound;
    CGPoint currentDownBound;
    //    <<<<<
}

@property (nonatomic,retain) HLBookEntity                *bookEntity;
@property (nonatomic,retain) HLPageController            *page1Controller;
@property (nonatomic,retain) HLPageController            *page2Controller;
@property (nonatomic,retain) HLPageController            *page3Controller;
@property (nonatomic,retain) UIScrollView              *pageScrollView;
@property (nonatomic,assign) HLBehaviorController        *behController;
@property (nonatomic,retain) HLPageEntity                *currentPageEntity;//(陈星宇，10。30，assign －> retain) <- 这么改是错的_(:з」∠)_
@property (nonatomic,assign) NSString                  *rootPath;
@property (nonatomic,assign) HLPageController            *currentPageController;
@property (nonatomic,assign) HLSliderFlipController      *sliderFlipController;
@property (nonatomic,assign) HLSliderCoverPageController *coverPageController;

@property int pageIndex;
@property int subPageIndex;
@property Boolean isBusy;
@property Boolean isAutoPlay;

-(void) setup:(CGRect) rect;
-(void) loadPage:(HLPageEntity *) pageEntity;
-(void) beginView;
-(void) setupRootPath:(NSString *) path;
-(void) stopView;
-(void) clean;

-(void) changeSize:(CGSize) size;
-(Boolean) gotoPageWithPageID:(NSString *)pageid animate:(Boolean)animate;
-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

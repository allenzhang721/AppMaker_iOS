//
//  SliderPageController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-12-31.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageController.h"
#import "PageEntity.h"
#import "SliderFlipController.h"
#import "SliderPageContainerController.h"
#import "SliderCoverPageController.h"
#import "HLEnumConstant.h"

@class SliderFlipController;

@interface SliderPageController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    SliderPageContainerController *sliderContainerController;
    
    
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
@property (nonatomic,retain) PageController            *page1Controller;
@property (nonatomic,retain) PageController            *page2Controller;
@property (nonatomic,retain) PageController            *page3Controller;
@property (nonatomic,retain) UIScrollView              *pageScrollView;
@property (nonatomic,assign) BehaviorController        *behController;
@property (nonatomic,retain) PageEntity                *currentPageEntity;//(陈星宇，10。30，assign －> retain) <- 这么改是错的_(:з」∠)_
@property (nonatomic,assign) NSString                  *rootPath;
@property (nonatomic,assign) PageController            *currentPageController;
@property (nonatomic,assign) SliderFlipController      *sliderFlipController;
@property (nonatomic,assign) SliderCoverPageController *coverPageController;

@property int pageIndex;
@property int subPageIndex;
@property Boolean isBusy;
@property Boolean isAutoPlay;

-(void) setup:(CGRect) rect;
-(void) loadPage:(PageEntity *) pageEntity;
-(void) beginView;
-(void) setupRootPath:(NSString *) path;
-(void) stopView;
-(void) clean;

-(void) changeSize:(CGSize) size;
-(Boolean) gotoPageWithPageID:(NSString *)pageid animate:(Boolean)animate;
-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

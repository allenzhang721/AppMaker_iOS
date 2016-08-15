//
//  FlipBaseController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "BehaviorController.h"
#import "HLBookEntity.h"
#import "FlipBaseViewController.h"
#import "NavView.h"
#import "WebViewController.h"
#import "BookViewController.h"
#import "BaseControlPanelViewController.h"
#import "Container.h"
#import "appMaker.h"
#import "CoverBaseViewController.h"

@class BaseControlPanelViewController;
@class BookViewController; //11.27
@class CoverBaseController;

@interface FlipBaseController : NSObject<UIAlertViewDelegate>
{
    int currentPageIndex;
    AVAudioPlayer *flipSound;
    UIView *_shareView;
    BOOL _canPrient;
}

@property BOOL isOrientation;
@property BOOL isVerticalPageType;
@property int currentSectionIndex;
@property int currentPageIndex;
@property (nonatomic , assign)    HLBookEntity                       *bookEntity;
@property (nonatomic , assign)    BookViewController               *bookViewController;
@property (nonatomic , retain)    BehaviorController               *behaviorController;
@property (nonatomic , retain)    NSMutableArray                   *sectionPages;
@property (nonatomic , retain)    NSMutableArray                   *sectionSnapshots;
@property (nonatomic , retain)    NSString                         *rootPath;
@property (nonatomic , retain)    NSString                         *currentPageid;
@property (nonatomic , copy)      NSString                         *homePageid;
@property (nonatomic , retain)    AVAudioPlayer                    *backgroundMusic;
@property (nonatomic , assign)    FlipBaseViewController           *viewController;
@property (nonatomic , assign)    BaseControlPanelViewController   *controlPanelViewController;
@property (nonatomic , retain)    NavView                          *navView;
@property (nonatomic , retain)    WebViewController                *webViewController;
@property (nonatomic , assign)    int preSectionIndex;
@property (nonatomic , assign)    int nextSectionIndex;//added by Adward 13-12-18
@property (nonatomic , assign)    Boolean confireGotoPage;//added by Adward 13-12-18

//  >>>>> 1.2 , pulbicCover
@property (nonatomic , retain)    CoverBaseController              *coverController;
//  <<<<<


@property Boolean isBusy;

-(void) openBook;
-(void) strartView;

-(void) nextPage;
-(void) prePage;
-(void) homePage;
-(void) onNav;
-(void) popDownNav;
-(void) popDownControlPanel;
-(void) close;
-(void) enableAction;
-(void) disableAction;
-(void) print:(Container *)container;
//分享
- (void)showShareView:(NSString *)contentStr type:(HLWeiboType)type;
-(BOOL) gotoPageWithPageID:(NSString *)pageid animate:(Boolean)animate;
-(BOOL) gotoPage:(int)index animate:(Boolean)animate;   //陈星宇
-(void) confireGotoPage:(int)index animate:(Boolean)animate;   //陈星宇
-(void) stopBackgroundMusic;
-(void) playBackgroundMusic;
-(void) pauseBackgroundMusic;
-(BOOL) returnToLastPage:(Boolean) animate;
-(void) popWebview:(NSString *) url;
-(void) setAutoPlay:(Boolean) value;
-(CGRect) getPageRect;
-(int)  searchPageIndex:(NSString *) pageid;

-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(void) changeToOrientation:(UIInterfaceOrientation)interfaceOrientation;



//added by Adward
-(void)displayPageWithAnimation;
//-(void)loadPage:(int)index;
- (void)changePage;
-(void)animationBegin;
-(void)animationEnd;
-(void)delayShow;
-(void)setChangePageAniProperty;

extern CATransition *KpageChangeAnimation;//全局变量动画

@end

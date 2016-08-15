//
//  FlipBaseController.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "FlipBaseController.h"
#import "PageEntity.h"
#import "PageDecoder.h"
#import "ImageComponent.h"
#import "BookController.h"
#import "BasicControlPanelViewController.h"
#import "IAPPurchseHandle.h"
#import "PageController.h"

#import "LocalizationDefine.h"      //陈星宇，11.22，国际化

#define kPAGECHANGEANIMATION @"animationPageChange"

CATransition *KpageChangeAnimation;

@interface FlipBaseController ()        //陈星宇

{
    int indexPage;
    NSString *pageID;
    Boolean animatePage;
}

@end

@implementation FlipBaseController
@synthesize viewController;
@synthesize rootPath;
@synthesize currentSectionIndex;
@synthesize currentPageIndex;
@synthesize bookEntity;
@synthesize sectionPages;
@synthesize sectionSnapshots;
@synthesize controlPanelViewController;
@synthesize navView;
@synthesize behaviorController;
@synthesize backgroundMusic;
@synthesize isBusy;

@synthesize preSectionIndex;
@synthesize nextSectionIndex;
@synthesize confireGotoPage;

#pragma mark -
#pragma mark - Method

#pragma mark -
#pragma mark - interface

-(void) strartView {};
-(void) nextPage   {};
-(void) prePage    {};
-(void) homePage   {};
-(void)confireGotoPage:(int)index animate:(Boolean)animate {}; //陈星宇 flipBase
-(void) onNav      {};
-(void) enableAction {};
-(void) disableAction {};

- (void)changePage    //作为接口，供其他子类调用
{
    //added by Adward 13-11-27 如果没有动画，默认方式跳转
    PageEntity *pageEntity = self.behaviorController.pageController.pageViewController.pageEntity;
    if([pageEntity.animationType isEqualToString:[NSString stringWithFormat:@"%d",pageChangeAnimationTypeNon]]||pageEntity.animationType == nil)
    {
        [self delayShow];
    }
    else
    {
        [self displayPageWithAnimation];
    }
}
-(void)delayShow{};
-(BOOL) returnToLastPage:(Boolean) animate {};

#pragma mark -
#pragma mark - Init Method
-(void) openBook
{
    self.currentSectionIndex = 0;
    self.currentPageIndex    = 0;
    self.confireGotoPage     = NO;
    _canPrient = YES;
    self.isOrientation = YES;
    if (self.bookEntity != nil)
    {
        self.sectionPages     = [self.bookEntity getSectionPages:self.currentSectionIndex];
        self.sectionSnapshots = [self.bookEntity getSectionSnapshots:self.currentSectionIndex];
        if ([self.bookEntity.backgroundMusic length] > 0)
        {
            NSString *mp3File = [self.rootPath stringByAppendingPathComponent:self.bookEntity.backgroundMusic];
            NSURL *url = [NSURL fileURLWithPath:mp3File];
            self.backgroundMusic = [[[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL] autorelease];
            [self.backgroundMusic prepareToPlay];
            self.backgroundMusic.numberOfLoops = -1;
        }
    }
    if (self.webViewController ==nil)
    {
        // self.webViewController = [[[WebViewController alloc] init] autorelease];
    }
    // self.webViewController.view.frame = CGRectMake(0, 0, self.viewController.view.frame.size.width, self.viewController.view.frame.size.height);
    // [self.webViewController setupView];
    self.isBusy = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackgroundMusic) name:@"PlayBackgroundMusic" object:nil];
}


#pragma mark -
#pragma mark - pageChage Control
//陈星宇 修改 void
-(BOOL) gotoPage:(int)index animate:(Boolean) animate
{
    //找到page实体
    PageEntity *pageEntity = [PageDecoder decode:[self.sectionPages objectAtIndex:index] path:self.rootPath];
    if (pageEntity.isNeedPay == YES)
    {
                //Mr.chen, Modify Purchse , 14.03.30
//        if (self.bookEntity.isPaid == NO)
//        {
//            NSString *attion = nil;
//            NSString *PurchseOrNot = nil;
//            NSString *cancel = nil;
//            NSString *purchse = nil;
//            
//#if SIMP == 1
//            attion = @"提醒";
//            PurchseOrNot = @"将要看到的为付费页，确定要购买吗？";
//            cancel = @"取消";
//            purchse = @"购买";
//            
//#elif TAIWAN == 1
//            attion = @"提醒";
//            PurchseOrNot = @"將要看到的內容爲付費頁，確定購買嗎？";
//            cancel = @"取消";
//            purchse = @"購買";
//#elifJAP == 1
//            attion = @"情報";
//            PurchseOrNot = @"ここからは有料となります。購入しますか？";
//            cancel = @"キャンセル";
//            purchse = @"購入";
//#endif
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:attion message:PurchseOrNot delegate:self cancelButtonTitle:cancel otherButtonTitles:purchse, nil];
//            alert.tag = 0;
//            [alert show];
//            [alert release];
//            
//            indexPage = index;
//            animatePage = animate;
//            
//            return NO;
//        }
//        else
//        {
            [self confireGotoPage:index animate:animate];

            return YES;
//        }
    }
    else
    {
        [self confireGotoPage:index animate:animate];
    }
    
    return YES;
}


-(BOOL) gotoPageWithPageID:(NSString *)pageid animate:(Boolean)animate
{
    
    int index = [self searchPageIndex:pageid];
    PageEntity *pageEntity =nil;
    if(index!= -1)
    {
        pageEntity = [PageDecoder decode:[self.sectionPages objectAtIndex:index] path:self.rootPath];
    }
    else
    {
        int sectionIndex = [self.bookEntity getPageSection:pageid];
        if(sectionIndex == -1)
        {
            pageEntity = nil;
        }
        else
        {
            PageEntity *currentPage = [PageDecoder decode:self.currentPageid path:self.rootPath] ;
            //            NSLog(@"currentPageid:%@ rootPath:%@ sectionPages:%@",self.currentPageid,self.rootPath,self.sectionPages);
            if ([currentPage.linkPageID isEqualToString:pageid] == NO)
            {
                pageEntity =  [PageDecoder decode:pageid path:self.rootPath];
                
                if (pageEntity != nil)
                {
                    if (self.bookEntity.isVerHorMode && pageEntity.isVerticalPageType != [self isDeviceVertical])
                    {
                        if ([pageEntity.linkPageID length] > 0 )
                        {
                            pageEntity = [PageDecoder decode:pageEntity.linkPageID path:self.rootPath];
                        }
                    }
                }
            }
            else
            {
                [self confireGotoPageWithPageID:currentPage.linkPageID animate:animate];        //陈星宇，11.27，12.13，横竖屏切换
                
//                return YES;
            }
        }
    }
    if(pageEntity != nil)
    {
        
        //Mr.chen, Modify Purchse , 14.03.30
//        if(pageEntity.isNeedPay == YES)
//        {
//            if (self.bookEntity.isPaid == NO)
//            {
//                NSString *attion = nil;
//                NSString *PurchseOrNot = nil;
//                NSString *cancel = nil;
//                NSString *purchse = nil;
//                
//#if SIMP == 1
//                attion = @"提醒";
//                PurchseOrNot = @"将要看到的为付费页，确定要购买吗？";
//                cancel = @"取消";
//                purchse = @"购买";
//                
//#elif TAIWAN == 1
//                attion = @"提醒";
//                PurchseOrNot = @"將要看到的內容爲付費頁，確定購買嗎？";
//                cancel = @"取消";
//                purchse = @"購買";
//#elifJAP == 1
//                attion = @"情報";
//                PurchseOrNot = @"ここからは有料となります。購入しますか？";
//                cancel = @"キャンセル";
//                purchse = @"購入";
//#endif
//                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:attion message:PurchseOrNot delegate:self cancelButtonTitle:cancel otherButtonTitles:purchse, nil];
//                
//                alert.tag = 1;
//                [alert show];
//                [alert release];
//                
//                pageID = pageid;
//                animatePage = animate;
//            }
//            else
//            {
//                [self confireGotoPageWithPageID:pageid animate:animate];
//            }
//        }
//        else
//        {
            [self confireGotoPageWithPageID:pageid animate:animate];
//        }
        return YES;
    }
    else
    {
        NSLog(@"nonononoonoon");
        return NO;
    }
}

- (void) confireGotoPageWithPageID:(NSString *)pageid animate:(Boolean) animate{
    
    self.confireGotoPage = YES;
    
    int sectionIndex = [self.bookEntity getPageSection:pageid];
    
    int index = [self searchPageIndex:pageid];
    
    self.nextSectionIndex = sectionIndex;//added by Adward 13-12-18
    self.preSectionIndex = [self.bookEntity getPageSection:self.currentPageid];
    if (index != -1)    //
    {
        [self confireGotoPage:index animate:animate];
    }
    else
    {
        PageEntity* currentPage = [PageDecoder decode:self.currentPageid path:self.rootPath] ;
        if ([currentPage.linkPageID isEqualToString:pageid] == NO)
        {
            PageEntity *pe =  [PageDecoder decode:pageid path:self.rootPath];
            
            if (pe != nil)
            {
                if (self.bookEntity.isVerHorMode && pe.isVerticalPageType != [self isDeviceVertical])
                {
                    if ([pe.linkPageID length] > 0 )
                    {
                        [self gotoPageWithPageID:pe.linkPageID animate:animate];
                        return;
                    }
                    else
                    {
                        return;
                    }
                }
            }
        }
        
        if (sectionIndex != -1)
        {
            currentSectionIndex = sectionIndex;
            self.sectionPages             = [self.bookEntity getSectionPages:sectionIndex];
            self.sectionSnapshots         = [self.bookEntity getSectionSnapshots:sectionIndex];
            self.navView.snapTitles       = [self.bookEntity getSectionSnapTitles:sectionIndex];
            self.navView.snapshots        = self.sectionSnapshots;
            [self.navView refresh];
            self.currentPageIndex  = -1;
            [self confireGotoPageWithPageID:pageid animate:animate];
        }
    }
    
}

#pragma mark -
#pragma mark - Purchse and Alert Delegate
//陈星宇,10.24,支付
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1)
    {
        //陈星宇,Purchse and Next page
        [self purchseActionWithAlertView:alertView];
    }
}

- (void)purchseActionWithAlertView:(UIAlertView *)alertView
{
    IAPPurchseHandle *purchseHandle = [IAPPurchseHandle shareInstance];//用单例，添加观察者
    if ([purchseHandle canMakePayment])
    {
        [purchseHandle getProductInfoWithPoductID:self.bookEntity.productID];
    }
    else
    {
        NSString *attion = nil;
        NSString *ForbidPurchsing = nil;
        NSString *cancel = nil;
        NSString *confirm = nil;
        
//#if SIMP == 1
        attion = kAttention;
        ForbidPurchsing = kUserForbidPurchsing;
        cancel = kCancel;
        confirm = kConfire;
        
//#elif TAIWAN == 1
//        attion = @"提醒";
//        ForbidPurchsing = @"您已禁止應用內購買";
//        cancel = @"取消";
//        confirm = @"確定";
//#elifJAP == 1
//        attion = @"情報";
//        ForbidPurchsing = @"アプリ内購入が拒否されました。";
//        cancel = @"キャンセル";
//        confirm = @"确定";
//#endif
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:attion message:ForbidPurchsing delegate:Nil cancelButtonTitle:confirm otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
    }
    
    purchseHandle.compeleteTransactionBlock = ^(SKPaymentTransaction * transaction)     //交易完成
    {
        self.bookEntity.isPaid = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.bookEntity.bookid];  //陈星宇，支付成功待议
        
        if (alertView.tag == 0)
        {
            [self confireGotoPage:indexPage animate:animatePage];
        }
        else if (alertView.tag == 1)
        {
            [self confireGotoPageWithPageID:pageID animate:animatePage];
        }
    };
    
    purchseHandle.restoredTransactionBlock = ^(SKPaymentTransaction * transaction)      //已内购恢复
    {
        self.bookEntity.isPaid = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.bookEntity.bookid];  //陈星宇，支付成功待议
        
        if (alertView.tag == 0)
        {
            [self confireGotoPage:indexPage animate:animatePage];
        }
        else if (alertView.tag == 1)
        {
            [self confireGotoPageWithPageID:pageID animate:animatePage];
        }
    };
    
    purchseHandle.failedTransactionBlock = ^(SKPaymentTransaction * transaction)        //交易失败
    {
        if(transaction.error.code != SKErrorPaymentCancelled) {
            
            NSString *attion = nil;
            NSString *failGet = nil;
            NSString *cancel = nil;
            NSString *confirm = nil;
            
//#if SIMP == 1
            attion = kAttention;
            failGet = kPurchseFail;
            cancel = kCancel;
            confirm = kConfire;
//            
//#elif TAIWAN == 1
//            attion = @"提醒";
//            failGet = @"購買失敗";
//            cancel = @"取消";
//            confirm = @"確定";
//#elifJAP == 1
//            attion = @"情報";
//            failGet = @"購入失敗。";
//            cancel = @"キャンセル";
//            confirm = @"确定";
//#endif
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:attion message:failGet delegate:nil cancelButtonTitle:confirm otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
        } else {
            NSLog(@"用户取消交易");
        }
    };
}

-(void) setAutoPlay:(Boolean) value {}

-(int)  searchPageIndex:(NSString *) pageid
{
    for (int i = 0; i < [self.sectionPages count];i++ )
    {
        if ([(NSString*)[self.sectionPages objectAtIndex:i] compare:pageid] == NSOrderedSame)
        {
            return i;
        }
    }
    return -1;
}


#pragma mark -
#pragma mark - Other
-(void) print:(Container *)container
{
    if (!_canPrient)
    {
        return;
    }
    _canPrient = NO;
    [self performSelector:@selector(recoverPrint) withObject:nil afterDelay:1];
    UIPrintInteractionController *pCon = [UIPrintInteractionController sharedPrintController];
    
    UIImage *img = ((ImageComponent *)container.component).imv.image;
    if(pCon && img )
    {
        NSString *jobName = nil;
        
#if TAIWAN == 1
        jobName = @"smart apps creator print";
#else
        jobName = @"appMakerPrint";
#endif
        
        UIPrintInfo *info = [UIPrintInfo printInfo];
        info.outputType = UIPrintInfoOutputGeneral;
        //        info.jobName = @"appBookPrint";
        info.jobName = jobName;
        info.duplex = UIPrintInfoDuplexLongEdge;
        pCon.printInfo = info;
        pCon.showsPageRange = YES;
        pCon.printingItem = img;
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (!completed && error)
                NSLog(@"FAILED! due to error in domain %@ with error code %u",error.domain, error.code);
        };
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            CGRect rect = CGRectMake(container.componetRect.origin.x, container.componetRect.origin.y, container.componetRect.size.width, container.componetRect.size.height);
            [pCon presentFromRect:rect inView:container.component.uicomponent.superview animated:YES completionHandler:completionHandler];
        } else
        {
            [pCon presentAnimated:YES completionHandler:completionHandler];
        }
    }
}

- (void)recoverPrint
{
    _canPrient = YES;
}

//接受消息
- (void)showShareView:(NSString *)contentStr type:(HLWeiboType)type
{
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.rootPath, [self.navView.snapshots objectAtIndex:self.currentPageIndex]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareToWeibo" object:[NSDictionary dictionaryWithObjectsAndKeys: path, @"path", contentStr, @"content", [NSNumber numberWithInt:type], @"type", nil]];
}

-(void) popDownControlPanel
{
    if (self.controlPanelViewController != nil)
    {
        [self.controlPanelViewController popDown];
    }
}

-(void) popDownNav
{
    if (self.navView != nil)
    {
        [self.navView popdown];
    }
}

-(void) close
{
    if (self.backgroundMusic != nil)
    {
        [self.backgroundMusic stop];
    }
}

-(Boolean) isDeviceVertical
{
    UIInterfaceOrientation or = [[UIApplication sharedApplication] statusBarOrientation];
    if ((or == UIInterfaceOrientationPortrait ) || (or == UIInterfaceOrientationPortraitUpsideDown))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)displayPageWithAnimation
{
    [self setChangePageAniProperty];
    [self addPageChangeAnimation];
}

- (void)setChangePageAniProperty
{
    KpageChangeAnimation = [CATransition animation];
    KpageChangeAnimation.delegate = self;
    PageEntity *pageEntity = self.behaviorController.pageController.pageViewController.pageEntity;
    float dur = [pageEntity.animationDuration floatValue] / 1000.0;
    NSLog(@"duration:%f",dur);
    KpageChangeAnimation.duration = dur;
    KpageChangeAnimation.timingFunction = UIViewAnimationCurveEaseInOut;
    switch ([pageEntity.animationType intValue])
    {
        case pageChangeAnimationTypeFade:
            KpageChangeAnimation.type = kCATransitionFade;
            break;
        case pageChangeAnimationTypePush:
            KpageChangeAnimation.type = kCATransitionPush;
            break;
        case pageChangeAnimationTypeReveal:
            KpageChangeAnimation.type = kCATransitionReveal;
            break;
        case pageChangeAnimationTypeMoveIn://覆盖
            KpageChangeAnimation.type = kCATransitionMoveIn;
            break;
        case pageChangeAnimationTypeCubeEffect://立方体
            KpageChangeAnimation.type = @"cube";
            break;
        case pageChangeAnimationTypeSuckEffect:
            KpageChangeAnimation.type = @"suckEffect";//吸收
            break;
        case pageChangeAnimationTypeFlipEffect:
            KpageChangeAnimation.type = @"oglFlip";//翻转
            break;
        case pageChangeAnimationTypeRippleEffect:
            KpageChangeAnimation.type = @"rippleEffect";
            break;
        case pageChangeAnimationTypePageCurl:
            KpageChangeAnimation.type = @"pageCurl";
            break;
        case pageChangeAnimationTypePageUnCul:
            KpageChangeAnimation.type = @"pageUnCurl";
            break;
        default:
            break;
    }
    
    switch ([pageEntity.animationDir intValue])
    {
        case pageChangeHLAnimationDirLeft:
            KpageChangeAnimation.subtype = kCATransitionFromRight;
            break;
        case pageChangeHLAnimationDirDown:
            KpageChangeAnimation.subtype = kCATransitionFromTop;
            break;
        case pageChangeHLAnimationDirRight:
            KpageChangeAnimation.subtype = kCATransitionFromLeft;
            break;
        case pageChangeHLAnimationDirUp:
            KpageChangeAnimation.subtype = kCATransitionFromBottom;
            break;
        default:
            break;
    }
    
//    [self animationBegin];
//    [NSTimer scheduledTimerWithTimeInterval:dur target:self selector:@selector(animationEnd) userInfo:nil repeats:NO];
}



-(void)addPageChangeAnimation
{
    PageViewController *pageViewController = self.behaviorController.pageController.pageViewController;
    [pageViewController.view.layer addAnimation:KpageChangeAnimation forKey:kPAGECHANGEANIMATION];
}

- (void)animationDidStart:(CAAnimation *)anim
{
//     NSLog(@"TRANSATION_START");
    [self animationBegin];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    NSLog(@"TRANSATION_END");
    [self animationEnd];
}

-(void)animationBegin{}
-(void)animationEnd{}

-(void) stopBackgroundMusic
{
    if(self.backgroundMusic != nil)
    {
        [self.backgroundMusic stop];
        self.backgroundMusic.currentTime = 0;
        if ([self.bookViewController.bookController.controlPanelViewController isKindOfClass:[BasicControlPanelViewController class]])
        {
            ((BasicControlPanelViewController *)self.bookViewController.bookController.controlPanelViewController).btnBgMusic.selected = YES;
        }
    }
}

-(void) playBackgroundMusic
{
    if(self.backgroundMusic != nil)
    {
        [self.backgroundMusic play];
        if ([self.bookViewController.bookController.controlPanelViewController isKindOfClass:[BasicControlPanelViewController class]])
        {
            ((BasicControlPanelViewController *)self.bookViewController.bookController.controlPanelViewController).btnBgMusic.selected = NO;
        }
    }
}

-(void) pauseBackgroundMusic
{
    if (self.backgroundMusic != nil)
    {
        [self.backgroundMusic pause];
        if ([self.bookViewController.bookController.controlPanelViewController isKindOfClass:[BasicControlPanelViewController class]])
        {
            ((BasicControlPanelViewController *)self.bookViewController.bookController.controlPanelViewController).btnBgMusic.selected = YES;
        }
    }
}

-(void) popWebview:(NSString *) url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
    //    [self.viewController presentViewController:self.webViewController animated:YES completion:nil];
    //    [self.webViewController loadUrl:url];
}

-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}
-(void) changeToOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
}

-(CGRect) getPageRect   {return self.viewController.view.frame;}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PlayBackgroundMusic" object:nil];
    [flipSound stop];
    [flipSound release];
    [self.navView removeFromSuperview];
    [self.behaviorController release];
    [self.rootPath release];
    [self.navView release];
    [self.sectionPages removeAllObjects];
    [self.sectionPages release];
    [self.sectionSnapshots removeAllObjects];
    [self.sectionSnapshots release];
    [self.currentPageid release];
    [self.homePageid release];
    [self.backgroundMusic stop];
    [self.backgroundMusic release];
    [self.coverController release];
    // [self.webViewController.view removeFromSuperview];
    //[self.webViewController release];
    [super dealloc];
}

@end

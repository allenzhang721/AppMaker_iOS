//
//  SliderFlipController.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-12-31.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLSliderFlipController.h"
#import "HLFlowCoverNavigationView.h"
#import "HLBasicControlPanelViewController.h"
#import "HLPageEntity.h"
#import "HLLineCoverNavigationView.h"
#import "HLBookController.h"

#define KNOTIFICATION_PAGEDRAGGING      @"PageBeginDragging"
#define KNOTIFICATION_PAGECHANGE        @"PageChangeRefreshTag"

@interface HLSliderFlipController ()

{
    CGPoint beginDragPoint;
}

@end

@implementation HLSliderFlipController

@synthesize page1Controller;
@synthesize page2Controller;
@synthesize page3Controller;
@synthesize currentPageController;
@synthesize scrollView;
@synthesize isWithGotoSubPage;
@synthesize isWithSectionChange;
@synthesize subpageid;
@synthesize canScroll;

#pragma mark -
#pragma mark - Mehtod

#pragma mark -
#pragma mark - Init
- (id)init
{
    self = [super init];
    if (self)
    {
        if (self.page1Controller == nil)
        {
            self.page1Controller = [[HLSliderPageController alloc] init];                     //10.30
            [page1Controller release];
        }
        if (self.page2Controller == nil)
        {
            self.page2Controller = [[HLSliderPageController alloc] init];
            [page2Controller release];
        }
        if (self.page3Controller == nil)
        {
            self.page3Controller = [[HLSliderPageController alloc] init];
            [page3Controller release];
        }
        if (self.scrollView == nil)
        {
            self.scrollView = [[UIScrollView alloc] init];
            [scrollView release];
        }
        self.behaviorController = [[[HLBehaviorController alloc]init] autorelease];
        self.behaviorController.flipController = self;
        self.page1Controller.behController = self.behaviorController;
        self.page2Controller.behController = self.behaviorController;
        self.page3Controller.behController = self.behaviorController;
        self.isWithGotoSubPage             = NO;
        self.isWithSectionChange           = NO;
        self.isBusy                        = NO;
        self.navView.flipView              = self;
        isGotoPage                         = NO;
        
        _goBackArray = [[NSMutableArray alloc] init];
        
        sliderContainerController = [[HLSliderContainerController alloc] init];
        canScroll = YES;
        
        //      >>>>> 1.3
        changeLeftCover = NO;
        changeRightCover = NO;
        endDecelerate = YES;
        self.coverController = [[HLSliderCoverController alloc] init];
        self.coverController.flipController = self;
        self.coverController.behaviorController.flipController = self;
        //      <<<<<
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setScrollVIewEnabled:) name:@"NotificationScrollEnabled" object:nil];
    }
    return self;
}


- (void) stop {
    
    
}

-(void) openBook
{
    [super openBook];
    [self.page1Controller setupRootPath:self.rootPath];
    [self.page2Controller setupRootPath:self.rootPath];
    [self.page3Controller setupRootPath:self.rootPath];
    self.page1Controller.bookEntity = self.bookEntity;
    self.page2Controller.bookEntity = self.bookEntity;
    self.page3Controller.bookEntity = self.bookEntity;
    self.page1Controller.sliderFlipController = self;
    self.page2Controller.sliderFlipController = self;
    self.page3Controller.sliderFlipController = self;
    
    self.scrollView.frame         = CGRectMake(0, 0, self.viewController.view.frame.size.width, self.viewController.view.frame.size.height);
    self.scrollView.contentSize   = CGSizeMake(self.viewController.view.frame.size.width*3, self.viewController.view.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate      = self;
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator   = NO;
    
    [self.page1Controller setup:CGRectMake(self.viewController.view.frame.size.width * 0,
                                           0,
                                           self.viewController.view.frame.size.width,
                                           self.viewController.view.frame.size.height)];
    
    [self.page2Controller setup:CGRectMake(self.viewController.view.frame.size.width * 1,
                                           0,
                                           self.viewController.view.frame.size.width,
                                           self.viewController.view.frame.size.height)];
    
    [self.page3Controller setup:CGRectMake(self.viewController.view.frame.size.width*2,
                                           0,
                                           self.viewController.view.frame.size.width,
                                           self.viewController.view.frame.size.height)];
    
    
    self.page1Controller.view.frame = CGRectMake(self.viewController.view.frame.size.width * 0,
                                                 0,
                                                 self.viewController.view.frame.size.width,
                                                 self.viewController.view.frame.size.height);
    
    self.page2Controller.view.frame = CGRectMake(self.viewController.view.frame.size.width * 1,
                                                 0,
                                                 self.viewController.view.frame.size.width,
                                                 self.viewController.view.frame.size.height);
    
    self.page3Controller.view.frame = CGRectMake(self.viewController.view.frame.size.width * 2,
                                                 0,
                                                 self.viewController.view.frame.size.width,
                                                 self.viewController.view.frame.size.height);
    
    [self.scrollView addSubview:self.page1Controller.view];
    [self.scrollView addSubview:self.page2Controller.view];
    [self.scrollView addSubview:self.page3Controller.view];
    self.viewController.view.userInteractionEnabled = YES;
    [self.viewController.view addSubview:self.scrollView];
    
    if ([self.bookEntity.navType isEqualToString:@"threed_navigation_view"])
    {
        self.navView  = [[[HLFlowCoverNavigationView alloc] init] autorelease];
    }
    else
    {
        self.navView  = [[[HLLineCoverNavigationView alloc] init] autorelease];
    }
    self.navView.flipView = self;
    self.navView.rootpath = self.rootPath;
    self.navView.isVertical = self.bookEntity.isVerticalMode;
    self.navView.hidden = YES;
    self.navView.userInteractionEnabled = YES;
    [self.navView load];
    [self.viewController.view addSubview:self.navView];
    self.currentPageController = self.page1Controller;
    [self refreshLayout];
    
    //      >>>>>
    self.coverController.rootPath = self.rootPath;
    [self.coverController setup:CGRectMake(0,
                                           0,
                                           self.viewController.view.frame.size.width,
                                           self.viewController.view.frame.size.height)];
    
    [self.viewController.view addSubview:self.coverController.viewController.view];
    //      <<<<<
    
}

-(void) beginView
{
    [self.page1Controller beginView];
}

-(void) strartView
{
    if ([self.sectionPages count] >= 1)
    {
        [self resetPageLayout];
        self.scrollView.userInteractionEnabled = NO;
        HLPageEntity *pageEntity = [HLPageDecoder decode:self.bookEntity.launchPage path:self.rootPath];
        self.controlPanelViewController.view.hidden = YES;
        [self.page1Controller loadPage:pageEntity];
        [self.page1Controller beginView];
        [self performSelector:@selector(onLaunched) withObject:nil afterDelay:self.bookEntity.startDelay];      //陈星宇，11.3，延迟1秒
    }
}

-(void) onLaunched
{
    if ([self.sectionPages count] >= 1)
    {
        self.scrollView.userInteractionEnabled = YES;
        self.controlPanelViewController.view.hidden = NO;
        
        [self loadPage:self.currentPageIndex];
        
        self.navView.snapshots  = [self.bookEntity getSectionSnapshots:self.currentPageIndex];
        self.navView.snapshotsIndesign  = [self.bookEntity getIndesignSectionSnapshots:self.currentPageIndex rootPath:self.rootPath];
        self.navView.snapTitles = [self.bookEntity getSectionSnapTitles:self.currentPageIndex];
        self.navView.allPageIdArr = [self.bookEntity getAllPageId:self.currentSectionIndex rootPath:self.rootPath];
        if (!self.navView.allSectionPageId)
        {
            self.navView.allSectionPageId = [self.bookEntity getAllSectionPageId];
        }
        [self.navView refresh];
        self.navView.hidden = NO;
        if (self.backgroundMusic != nil)
        {
            [self.backgroundMusic play];
        }
        //        [self beginView];
    }
    NSString *pageId = ((HLSliderPageController *)self.currentPageController).currentPageEntity.entityid;
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PAGECHANGE object:pageId];
    
    //      >>>>> 1.2
    [self.coverController initEntity:((HLSliderPageController *)self.currentPageController).currentPageEntity];
    self.currentPageController.coverPageController = ((HLSliderCoverController *)self.coverController).currentPageController;
    //      <<<<<
    [self beginView];
}

#pragma mark -
#pragma mark - Cover
- (BOOL)changeCover:(CoverDirection)direction
{
    //      >>>>> 1.3
    NSString *curBecoverID = ((HLSliderCoverController *)self.coverController).currentPageController.currentCoverPageid;
    //    NSLog(@"curBecoverID = %@",curBecoverID);
    NSString *CompareBecoverID = nil;
    HLPageEntity *pageEntity = nil;
    
    switch (direction)
    {
        case CoverDirectionRight:
        {
            if (isGotoPage == NO) //手动翻页
            {
                if (self.currentPageIndex == self.sectionPages.count - 1)
                {
                    return NO;
                }
                
                if (self.currentPageIndex + 1 < self.sectionPages.count)
                {
                    pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:(self.currentPageIndex + 1)] path:self.rootPath];
                }
            }
            else //跳转翻页
            {
                if (self.currentPageIndex <= self.sectionPages.count - 1)
                {
                    pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:(self.currentPageIndex)] path:self.rootPath];
                }
            }
        }
            break;
            
        case CoverDirectionLeft:
        {
            if (isGotoPage == NO)
            {
                if (self.currentPageIndex == 0)
                {
                    return NO;
                }
                
                if (0 <= self.currentPageIndex - 1  &&  self.currentPageIndex - 1 < self.sectionPages.count)
                {
                    pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageIndex - 1] path:self.rootPath];
                }
            }
            else
            {
                if (self.currentPageIndex <= self.sectionPages.count - 1)
                {
                    pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:(self.currentPageIndex)] path:self.rootPath];
                }
            }
        }
            break;
    }
    
    CompareBecoverID = pageEntity.beCoveredPageID;
    
    if (curBecoverID == nil)
    {
        curBecoverID = @"";
    }
    if (CompareBecoverID == nil)
    {
        CompareBecoverID = @"";
    }
    
    if ([curBecoverID isEqualToString:CompareBecoverID])
    {
        return NO;
    }
    else
    {
        switch (direction)
        {
            case CoverDirectionLeft:
            {
                [self.coverController loadCoverPageEntity:pageEntity direction:CCoverDirectionLeft];
            }
                break;
                
            case CoverDirectionRight:
            {
                [self.coverController loadCoverPageEntity:pageEntity direction:CCoverDirectionRight];
            }
                break;
        }
        return YES;
    }
    //      <<<<<
}

#pragma mark -
#pragma mark - check direction
- (BOOL)scrollViewShouldScroll:(relativeDirection)direction
{
    BOOL shouldScroll = NO;
    HLPageEntity *pageEntity = nil;
    
    if (direction == relativeDirectionleft) {
        
        //check leftPage wether should pay, then check wether should scroll
        if (self.currentPageIndex == 0)
        {
            shouldScroll = YES;
        }
        else
        {
            if (0 <= self.currentPageIndex - 1  &&  self.currentPageIndex - 1 < self.sectionPages.count)
            {
                pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageIndex - 1] path:self.rootPath];
            }
            else
            {
                shouldScroll = NO;
            }
        }
        
    }
    else if (direction == relativeDirectionRight)
    {
        
        if (self.currentPageIndex == self.sectionPages.count - 1)
        {
            shouldScroll = YES;
        }
        else
        {
            if (self.currentPageIndex <= self.sectionPages.count - 1)
            {
                pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:(self.currentPageIndex)] path:self.rootPath];
            }
            else
            {
                shouldScroll = NO;
            }
        }
        
    }
    
    if(pageEntity != nil)
    {
        if(pageEntity.isNeedPay == YES)
        {
            if (self.bookEntity.isPaid == NO)
            {
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
                
//                pageID = thePageid;
//                animatePage = animate;
                shouldScroll = NO;
            }
            else
            {
                shouldScroll = YES;
            }
        }
        else
        {
            shouldScroll = YES;
        }
//        return YES;
    }
    else
    {
        shouldScroll = NO;
    }
    
    return shouldScroll;
}

- (relativeDirection)scllViewWillScrollDirection:(UIScrollView *)scrollView
{
    return relativeDirectionleft ? relativeDirectionRight : beginDragPoint.x > self.scrollView.contentOffset.x;
}

#pragma mark -
#pragma mark - Drag To Page
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //checkDirection
//    beginDragPoint = self.scrollView.contentOffset;
    
    //    NSLog(@"scrollViewWillBeginDragging");
    sliderContainerController.beginDragX = self.scrollView.contentOffset.x;
    sliderContainerController.isInitPos = NO;
    sliderContainerController.scrollSpace = self.scrollView.frame.size.width;
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PAGEDRAGGING object:nil];
    
    //      >>>>>
//    shouldScrollLeft = [self scrollViewShouldScroll:relativeDirectionleft];
//    shouldScrollRight = [self scrollViewShouldScroll:relativeDirectionRight];
    
    //      <<<<<
    
    //      >>>>> 1.2
    [self.coverController scrollViewWillBeginDragging:self.scrollView]; //1.3
    currentLeftBound = self.scrollView.contentOffset;
    currentrightBound = CGPointMake(self.scrollView.contentOffset.x + self.scrollView.bounds.size.width, self.scrollView.contentOffset.y);
    endDecelerate = NO; //1.3
    changeLeftCover = NO;
    changeRightCover = NO;
    changeRightCover = [self changeCover:CoverDirectionRight];
    changeLeftCover  =  [self changeCover:CoverDirectionLeft];
//    NSLog(@"right = %d, left = %d",changeRightCover , changeLeftCover);
    //      <<<<<
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.scrollView.scrollEnabled = NO;
    self.page1Controller.view.userInteractionEnabled = NO;
    self.page2Controller.view.userInteractionEnabled = NO;
    self.page3Controller.view.userInteractionEnabled = NO;
    
    //    >>>>>  1.3
    [((HLSliderCoverController *)self.coverController) scrollViewWillBeginDecelerating:self.scrollView];
    //    <<<<<
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //      >>>>> 1.3
    endDecelerate = YES;
    [self.coverController scrollViewDidEndDecelerating:self.scrollView];
    //      <<<<<
    
    
    if ([self searchCurrentSliderPage] == self.currentPageController)//如果没有翻页成功，当前页面重新加载动画
    {
        
    }
    else
    {
//       [self.currentPageController clean];
//        [self.currentPageController loadPage:self.currentPageController.currentPageEntity];
        self.currentPageController = [self searchCurrentSliderPage];                            //找到当前显示的页
        self.currentPageIndex      = self.currentPageController.pageIndex;
        
        //      >>>>> 1.3
        self.currentPageController.coverPageController = ((HLSliderCoverController *)self.coverController).currentPageController;
        //      <<<<<
        
        [self arrangePage];
        
        [self.controlPanelViewController refreshPanel:self.currentPageIndex count:[self.sectionPages count] enableNav:self.currentPageController.currentPageEntity.enbableNavigation];
        
        NSString *pageId = ((HLSliderPageController *)self.currentPageController).currentPageEntity.entityid;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PAGECHANGE object:pageId];//2013.04.22
        if ((_goBackArray.count > 0 && ![[_goBackArray objectAtIndex:_goBackArray.count - 1] isEqualToString:pageId]) ||
            _goBackArray.count == 0)
        {
            [_goBackArray addObject:pageId];
        }
        
        // Stop the left and right pages - - Emiaostein, 21 Mar 2017
        NSMutableArray<HLSliderPageController *> *pages = @[page1Controller, page2Controller, page3Controller];
        for (NSUInteger i = 0; i < 3; i++) {
            HLSliderPageController *p = [pages objectAtIndex:i];
            if ( p != currentPageController) {
                [p reset];
            }
        }

        [self.currentPageController beginView];
    }
    
    self.scrollView.scrollEnabled = canScroll;
    
    [self performSelector:@selector(beginViewCurrent) withObject:nil afterDelay:0.05];
    
    if (self.scrollView.contentSize.width - self.scrollView.frame.size.width <= 1)
    {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    

    
//    if (isGotoPage == NO)
//    {
//        relativeDirection direction = [self scllViewWillScrollDirection:self.scrollView];
//        
//        if (direction == relativeDirectionRight)
//        {
//            if (shouldScrollRight == NO)
//            {
//                
//            }
//        }
//        else
//        {
//            if (direction == relativeDirectionleft)
//            {
//                if (shouldScrollLeft == NO)
//                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"cancel", nil];
//                    
//                    alert.tag = 1;
//                    [alert show];
//                    [alert release];
//                }
//            }
//        }
//
//    }
    
    
    if (isGotoPage)
    {
        self.scrollView.scrollEnabled = NO;
    }

    sliderContainerController.page1Controller = [self firstPage];
    sliderContainerController.page2Controller = [self middlePage];
    sliderContainerController.page3Controller = [self lastPage];
    sliderContainerController.curPageController = self.currentPageController;   //当前屏幕上的pageViewControlelr
    
    [sliderContainerController scrollViewDidScroll:self.scrollView];
    //      >>>>> 1.2
    if (endDecelerate == NO)
    {
        //        NSLog(@"scrollViewDidScroll");
        if (changeRightCover == YES )
        {
            if (changeLeftCover == NO)
            {
                if (self.scrollView.contentOffset.x + self.viewController.view.frame.size.width - currentrightBound.x >= 0.000)
                {
                    [self.coverController scrollViewDidScroll:self.scrollView]; //1.3
                }
            }
            else
            {
                [self.coverController scrollViewDidScroll:self.scrollView]; //1.3
            }
            
        }
        else
        {
            if (changeLeftCover == NO)
            {
                
                
            }
            else
            {
                if (self.scrollView.contentOffset.x - currentLeftBound.x <= 0.000)
                {
                    [self.coverController scrollViewDidScroll:self.scrollView]; //1.3
                }
            }
        }
    }
    //      <<<<<
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    //    NSLog(@"targetContentOffset= %@",NSStringFromCGPoint(*targetContentOffset));
//}


#pragma mark -
#pragma mark - Go to Page
-(BOOL) returnToLastPage:(Boolean) animate
{
    if (_goBackArray.count <= 1)
    {
        _isGoBack = NO;
        return NO;
    }
    NSString *pageId = ((HLSliderPageController *)self.currentPageController).currentPageEntity.entityid;
    if ([pageId isEqualToString:[_goBackArray objectAtIndex:_goBackArray.count - 1]])
    {
        [_goBackArray removeObjectAtIndex:_goBackArray.count - 1];
    }
    _isGoBack = YES;
    return [self gotoPageWithPageID:[_goBackArray objectAtIndex:_goBackArray.count - 1] animate:animate];
    //    if (_goBackArray.count > 1)
    //    {
    //        [_goBackArray removeObjectAtIndex:_goBackArray.count - 1];
    //    }
}

- (void)confireGotoPage:(int)index animate:(Boolean)animate
{
    [self gotoPageWithPageID:(NSString *)[self.sectionPages objectAtIndex:index] animate:animate];
}

- (void)confireGotoPageWithPageID:(NSString *)pageid animate:(Boolean) animate
{
    
    if (!_isGoBack)
    {
        _isGoBack = NO;
        [_goBackArray addObject:pageid];
    }
    if (self.isBusy == YES)
    {
        return;
    }
    
    //  >>>>> 1.3 publicCover
    isGotoPage = YES;
    endDecelerate = NO;
    changeLeftCover = NO;
    changeRightCover = NO;
    //  >>>>>
    
    if ([self.currentPageController gotoPageWithPageID:pageid animate:animate] == NO)   //横向切换页
    {
        
        HLSliderPageController *fp = [self firstPage];
        HLSliderPageController *mp = [self middlePage];
        HLSliderPageController *lp = [self lastPage];
        self.isBusy = YES;
        int index = [self searchPageIndexInSection:pageid]; //是否在本section
        
        self.preSectionIndex = [self.bookEntity getPageSection:self.currentPageid];
        self.nextSectionIndex = [self.bookEntity getPageSection:pageid];
        
        if (index >= 0)     //在本section
        {
            self.currentPageIndex = index;
            if (index > self.currentPageController.pageIndex)                                   //需要加载右页，
            {
                
                if (self.currentPageController == fp) //当前页为第一页
                {
                    int pageCount = [self.sectionPages count] - 1; //最大页数
                    
                    if (index < pageCount || pageCount == 1) //有后页
                    {
                        
                        HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:index] path:self.rootPath];
                        [mp loadPage:pageEntity];
                        mp.pageIndex = index;
                        
                        currentLeftBound = self.scrollView.contentOffset;
                        currentrightBound = CGPointMake(self.scrollView.contentOffset.x + self.scrollView.bounds.size.width, self.scrollView.contentOffset.y);
                        
                        changeRightCover = [self changeCover:CoverDirectionRight];      //检测右边
                        
                        [(HLSliderCoverController *)self.coverController scrollViewBeginGoToPage:self.scrollView];
                        
                        [self.scrollView setContentOffset:CGPointMake(mp.view.frame.origin.x, mp.view.frame.origin.y) animated:animate];    //滚动到后页
//                        NSLog(@"111111");
                    }
                    else //pagecout >=2 有三页
                    {
                        CGRect fpr    = fp.view.frame;
                        fp.view.frame = mp.view.frame;
                        mp.view.frame = fpr;
                        
                        [self.scrollView setContentOffset:CGPointMake(fp.view.frame.origin.x, fp.view.frame.origin.y)];  //处于中间页位置
                        self.isBusy = NO;
                        [self gotoPageWithPageID:pageid animate:animate];  //调整位置，再走一次，有动画效果
//                        NSLog(@"2222222");
                        return ;
                    }
                }
                else  //不是第一页
                {
                    if (self.currentPageController == mp)  //为中间页
                    {
                        
                        
                        HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:index] path:self.rootPath];
                        [lp loadPage:pageEntity];
                        lp.pageIndex = index;
                        
                        currentLeftBound = self.scrollView.contentOffset;
                        currentrightBound = CGPointMake(self.scrollView.contentOffset.x + self.scrollView.bounds.size.width, self.scrollView.contentOffset.y);
                        
                        changeRightCover = [self changeCover:CoverDirectionRight];      //检测右边
                        
                        
                        [(HLSliderCoverController *)self.coverController scrollViewBeginGoToPage:self.scrollView];
                        
                        [self.scrollView setContentOffset:CGPointMake(lp.view.frame.origin.x, lp.view.frame.origin.y) animated:animate];  //滚动到后页
//                        NSLog(@"333333");
                    }
                    else
                    {
                        if (self.currentPageController == lp)  //第三页
                        {
                            CGRect lpf    = lp.view.frame;
                            lp.view.frame = mp.view.frame;
                            mp.view.frame = lpf;
                            [self.scrollView setContentOffset:CGPointMake(lp.view.frame.origin.x, lp.view.frame.origin.y)]; //处于中间页位置
                            self.isBusy = NO;
                            [self gotoPageWithPageID:pageid animate:animate]; //调整位置，再走一次，有动画效果
//                            NSLog(@"4444444");
                            return ;
                        }
                    }
                }
            }
            else    //需要加载左页
            {
                
                if (index < self.currentPageController.pageIndex)
                {
                    if (self.currentPageController == mp)  //当前页为第二页
                    {
                        
                        HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:index] path:self.rootPath];
                        [fp loadPage:pageEntity];
                        fp.pageIndex = index;
                        
                        currentLeftBound = self.scrollView.contentOffset;
                        currentrightBound = CGPointMake(self.scrollView.contentOffset.x + self.scrollView.bounds.size.width, self.scrollView.contentOffset.y);
                        
                        changeLeftCover  =  [self changeCover:CoverDirectionLeft];   //检测左页
                        
                        [(HLSliderCoverController *)self.coverController scrollViewBeginGoToPage:self.scrollView];
                        
                        [self.scrollView setContentOffset:CGPointMake(fp.view.frame.origin.x, fp.view.frame.origin.y) animated:animate];  //滚动到前一页
//                        NSLog(@"5555555555");
                    }
                    else
                    {
                        if (self.currentPageController == lp)  //当前页为第三页
                        {
                            if (index > 0)
                            {
                                HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:index] path:self.rootPath];
                                [mp loadPage:pageEntity];
                                mp.pageIndex = index;
                                
                                currentLeftBound = self.scrollView.contentOffset;
                                currentrightBound = CGPointMake(self.scrollView.contentOffset.x + self.scrollView.bounds.size.width, self.scrollView.contentOffset.y);
                                
                                
                                changeLeftCover  =  [self changeCover:CoverDirectionLeft];   //检测左页
                                
                                [(HLSliderCoverController *)self.coverController scrollViewBeginGoToPage:self.scrollView];
                                
                                [self.scrollView setContentOffset:CGPointMake(mp.view.frame.origin.x, mp.view.frame.origin.y) animated:animate]; //滚动到前一页
                            }
                            else //index <= 0
                            {
                                CGRect lpf = lp.view.frame;
                                lp.view.frame = mp.view.frame;
                                mp.view.frame = lpf;
                                [self.scrollView setContentOffset:CGPointMake(lp.view.frame.origin.x, lp.view.frame.origin.y)]; //处于中间页位置
                                self.isBusy = NO;
                                [self gotoPageWithPageID:pageid animate:animate];   //调整位置，再走一次，有动画效果
//                                NSLog(@"6666666");
                                return;
                            }
                        }
                    }
                }
            }
        }
        else    //不在本section，跳节
        {
//            NSLog(@"else");
            HLPageEntity *pe = [self searchSubPageInSection:pageid];
            if (pe != nil) // 跳子页
            {
                self.subpageid         = pageid;
                self.isWithGotoSubPage = YES;
                self.isBusy = NO;
                [self gotoPageWithPageID:pe.entityid animate:animate];
            }
            else  // 跳节
            {
                int sectionIndex = [self.bookEntity getPageSection:pageid];
                if (sectionIndex != -1)
                {
                    [self addFullLayout];                                                                       //添加满三个page
                    self.sectionPages = [self.bookEntity getSectionPages:sectionIndex];                         //获得跳转后section 的全部page
                    self.sectionSnapshots         = [self.bookEntity getSectionSnapshots:sectionIndex];
                    self.navView.snapTitles       = [self.bookEntity getSectionSnapTitles:sectionIndex];
                    self.currentPageController.pageIndex = -1;                                                  //当前页页码设为－1
                    self.currentPageIndex                = -1;
                    self.isWithSectionChange             = YES;                                                 // section跳转状态
                    self.navView.isSectionChange         = YES;
                    self.navView.snapshots               = self.sectionSnapshots;
                    self.navView.snapshotsIndesign  = [self.bookEntity getIndesignSectionSnapshots:sectionIndex rootPath:self.rootPath];
                    self.navView.allPageIdArr = [self.bookEntity getAllPageId:sectionIndex rootPath:self.rootPath];
                    if (!self.navView.allSectionPageId)
                    {
                        self.navView.allSectionPageId = [self.bookEntity getAllSectionPageId];
                    }
                    [self.navView refresh];
                    self.isBusy = NO;
                    [self gotoPageWithPageID:pageid animate:animate];
                    return;
                }
            }
        }
        if (animate == NO)
        {
            [self displayPageWithAnimation];//12.24页面跳转效果
        }
        
        //        if (self.backgroundMusic != nil)
        //        {
        //            [self.backgroundMusic play];
        //        }
        if (index == -1) {
            index = 0;
        }
        //每次跳转都去刷新导航条
        HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:index] path:self.rootPath];
        [self.controlPanelViewController refreshPanel:self.currentPageIndex count:[self.sectionPages count] enableNav:pageEntity.enbableNavigation];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PAGECHANGE object:pageid];//2013.04.22
        
        if(self.navView.isPoped)
        {
            [self.navView popdown];
        }
    }
    else
    {
        isGotoPage = NO;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView   //跳转页滚动动画结束
{
    //    NSLog(@"scrollViewDidEndScrollingAnimation");
    
    //      >>>>> 1.2
    
    endDecelerate = YES;
    [self.coverController scrollViewDidEndDecelerating:self.scrollView];
    //      <<<<<
    
    if (isGotoPage)
    {
        self.scrollView.scrollEnabled = YES;
    }
    
    HLSliderPageController *fp = [self firstPage];
    HLSliderPageController *mp = [self middlePage];
    HLSliderPageController *lp = [self lastPage];
    
    [self.currentPageController clean];
//    [self.coverController clean];
    self.currentPageController = [self searchCurrentSliderPage];
    self.currentPageIndex      = self.currentPageController.pageIndex;  //加载当前屏幕页
    
    //      >>>>> 1.2
    self.currentPageController.coverPageController = ((HLSliderCoverController *)self.coverController).currentPageController;
    //      <<<<<
    
    if (self.currentPageController == mp)   //跳转后是中间页
    {
        if ((self.currentPageController.pageIndex - 1) >= 0) //有前页
        {
            HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:(self.currentPageController.pageIndex - 1)] path:self.rootPath];
            [fp loadPage:pageEntity];
            fp.pageIndex = self.currentPageController.pageIndex - 1;
        }
        
        int pageCount = [self.sectionPages count]-1; //总页数
        
        if (self.currentPageController.pageIndex < pageCount) //说明有后页
        {
            HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageController.pageIndex + 1] path:self.rootPath];
            [lp loadPage:pageEntity];
            lp.pageIndex = self.currentPageController.pageIndex + 1;
        }
    }
    else
    {
        if (self.currentPageController == lp)   //跳转后是最后一页
        {
            if (self.currentPageController.pageIndex > 0)
            {
                HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageController.pageIndex - 1] path:self.rootPath];
                [mp loadPage:pageEntity];
                mp.pageIndex = self.currentPageController.pageIndex-1;
                [self arrangePage];     //重新排列
            }
        }
        else
        {
            if (self.currentPageController == fp)  //跳转后是第一页
            {
                int pageCount = [self.sectionPages count]-1;
                if (self.currentPageController.pageIndex < pageCount)
                {
                    HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageController.pageIndex + 1] path:self.rootPath];
                    [mp loadPage:pageEntity];
                    mp.pageIndex = self.currentPageController.pageIndex + 1;
                    [self arrangePage]; //重新排列
                }
            }
        }
    }
    if (self.isWithSectionChange == YES)
    {
        [self afterSectionChange];  //跳转sectoin，并加载完成后，重新布局
    }
    else
    {
        if (self.isWithGotoSubPage == NO)  //走 subPage
        {
            [self.currentPageController beginView];
        }
        else
        {
//            NSLog(@"走子页");
            self.isBusy = NO;
            self.isWithGotoSubPage = NO;
            [self gotoPageWithPageID:self.subpageid animate:YES];
            //            [self.currentPageController gotoPageWithPageID:self.subpageid animate:YES];
            //            return;
        }
    }
    isGotoPage = NO;
    self.isBusy = NO;
    
    [self goToPageEnableAction];
    
}

#pragma mark -
#pragma mark - Get Page
-(HLSliderPageController*) firstPage   //scrollView最前页
{
    float p1dx = self.page1Controller.view.frame.origin.x;
    float p2dx = self.page2Controller.view.frame.origin.x;
    if (p1dx == 0)
    {
        return self.page1Controller;
    }
    else
    {
        if (p2dx == 0)
        {
            return self.page2Controller;
        }
        else
        {
            return self.page3Controller;
        }
    }
}

-(HLSliderPageController*) middlePage  //scrollView内中间页
{
    float p1dx = self.page1Controller.view.frame.origin.x;
    float p2dx = self.page2Controller.view.frame.origin.x;
    if (p1dx == self.viewController.view.frame.size.width)
    {
        return self.page1Controller;
    }
    else
    {
        if (p2dx == self.viewController.view.frame.size.width)
        {
            return self.page2Controller;
        }
        else
        {
            return self.page3Controller;
        }
    }
}

-(HLSliderPageController *) lastPage  //scrollView内最后页
{
    float p1dx = self.page1Controller.view.frame.origin.x;
    float p2dx = self.page2Controller.view.frame.origin.x;
    if (p1dx == self.viewController.view.frame.size.width*2)
    {
        return self.page1Controller;
    }
    else
    {
        if (p2dx == self.viewController.view.frame.size.width*2)
        {
            return self.page2Controller;
        }
        else
        {
            return self.page3Controller;
        }
    }
}

-(int) searchPageIndexInSection:(NSString *) pageid   //当前section内搜索页
{
    for (int i = 0 ; i < [self.sectionPages count]; i++)
    {
        if ([pageid isEqualToString:[self.sectionPages objectAtIndex:i]] == YES)
        {
            return i;
        }
    }
    return -1;
}

-(HLPageEntity *) searchSubPageInSection:(NSString *) pageid   //查找子页
{
    for (int i = 0; i < [self.sectionPages count]; i++)
    {
        HLPageEntity *pe = [HLPageDecoder decode:[self.sectionPages objectAtIndex:i] path:self.rootPath];
        for (int n = 0 ; n < [pe.navPages count]; n++)
        {
            if ([pageid isEqualToString:[pe.navPages objectAtIndex:n]] == YES )
            {
                return pe;
            }
        }
    }
    return nil;
}



//no
-(void)addPageChangeAnimation
{
    HLPageEntity *pageEntity = self.behaviorController.pageController.pageViewController.pageEntity;
    if(!([pageEntity.animationType isEqualToString:[NSString stringWithFormat:@"%d",pageChangeAnimationTypeNon]]||pageEntity.animationType == Nil))
    {
        [self.scrollView.layer addAnimation:KpageChangeAnimation forKey:@"animation"];
    }
    else
    {
        [self scrollViewDidEndScrollingAnimation:self.scrollView];      // 1.12
    }
}

//no
-(HLSliderPageController*) searchCurrentSliderPage   //找到当前屏幕内的ViewController
{
    float dx   = self.scrollView.contentOffset.x;
    float p1dx = self.page1Controller.view.frame.origin.x+self.page1Controller.view.frame.size.width;
    float p2dx = self.page2Controller.view.frame.origin.x+self.page2Controller.view.frame.size.width;
    if ((dx < p1dx) && (dx >= self.page1Controller.view.frame.origin.x))
    {
        return self.page1Controller;
    }
    else
    {
        if ((dx < p2dx) && (dx >= self.page2Controller.view.frame.origin.x))
        {
            return self.page2Controller;
        }
        else
        {
            return self.page3Controller;
        }
    }
}

#pragma mark -
#pragma mark - Layout Page

-(void) afterSectionChange  //切换section后布局
{
    self.isWithSectionChange = NO;
    HLSliderPageController *fp = [self firstPage];
    HLSliderPageController *mp = [self middlePage];
    HLSliderPageController *lp = [self lastPage];
    if (self.currentPageIndex == 0) //第一页
    {
        if (self.currentPageController == mp)  //是中间页
        {
            CGRect lpr = lp.view.frame;
            lp.view.frame = mp.view.frame;
            mp.view.frame = fp.view.frame;
            fp.view.frame = lpr;
            [self.scrollView setContentOffset:CGPointMake(mp.view.frame.origin.x, mp.view.frame.origin.y)];
        }
        else
        {
            if (self.currentPageController == lp)  //是最后一页
            {
                CGRect lpr    = lp.view.frame;
                lp.view.frame = fp.view.frame;
                fp.view.frame = lpr;
                [self.scrollView setContentOffset:CGPointMake(lp.view.frame.origin.x, lp.view.frame.origin.y)];
                if ([self.sectionPages count] > 1)
                {
                    HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageController.pageIndex + 1] path:self.rootPath];
                    [mp loadPage:pageEntity];
                    mp.pageIndex = self.currentPageController.pageIndex + 1;
                }
            }
        }
    }
    else
    {
        int pageCout = [self.sectionPages count] - 1;  //总页数
        if (self.currentPageIndex == pageCout)   //最后一页
        {
            if (pageCout == 1)  //总共只有两页
            {
                if (self.currentPageController == lp)  //如果是最后一页
                {
                    CGRect lpr = lp.view.frame;
                    lp.view.frame = mp.view.frame;
                    mp.view.frame = fp.view.frame;
                    fp.view.frame = lpr;
                    HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageController.pageIndex - 1] path:self.rootPath];
                    [mp loadPage:pageEntity];
                    mp.pageIndex = self.currentPageIndex - 1;
                    [self.scrollView setContentOffset:CGPointMake(lp.view.frame.origin.x, lp.view.frame.origin.y)];
                }
            }
            else
            {
                if (self.currentPageController == mp) //如果是中间页
                {
                    CGRect fpr = fp.view.frame;
                    fp.view.frame = mp.view.frame;
                    mp.view.frame = lp.view.frame;
                    lp.view.frame = fpr;
                    [self.scrollView setContentOffset:CGPointMake(mp.view.frame.origin.x, mp.view.frame.origin.y)];
                }
            }
        }
    }
    [self refreshLayout]; //确定切换后的scrollView的长度
    [self.currentPageController beginView];             //begainView
}

-(void) arrangePage  //重新排列
{
    HLSliderPageController *fp = [self firstPage];
    HLSliderPageController *mp = [self middlePage];
    HLSliderPageController *lp = [self lastPage];
    if (self.currentPageController == [self firstPage])
    {
        if (self.currentPageIndex > 0 ) //交换位置
        {
          HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageIndex - 1] path:self.rootPath];
          if(lp.currentPageEntity == nil || ![lp.currentPageEntity.entityid isEqualToString:pageEntity.entityid])
          {
            CGRect fpf    = fp.view.frame;
            fp.view.frame = mp.view.frame;
            mp.view.frame = lp.view.frame;
            lp.view.frame = fpf;
            self.scrollView.contentOffset = CGPointMake(self.currentPageController.view.frame.origin.x, 0);
            
            [lp loadPage:pageEntity];
            lp.pageIndex = self.currentPageIndex - 1;
          }
        }
    }
    else
    {
        if (self.currentPageController == [self middlePage]) //为中间页
        {
            int pageCount = [self.sectionPages count]-1; //总页数
            if (self.currentPageIndex < pageCount) //加载后页
            {
              HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageIndex + 1] path:self.rootPath] ;
                
              if(lp.currentPageEntity == nil || ![lp.currentPageEntity.entityid isEqualToString:pageEntity.entityid])
              {
                [lp loadPage:pageEntity];
                lp.pageIndex = self.currentPageIndex + 1;
              }
            }
            if (self.currentPageIndex > 0)  //加载前页
            {
              HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageIndex - 1] path:self.rootPath] ;
                NSLog(@"aaa = %@ bbb = %@", fp.currentPageEntity.entityid, pageEntity.entityid);
                
              if(fp.currentPageEntity == nil && ![fp.currentPageEntity.entityid isEqualToString:pageEntity.entityid])
              {
                [fp loadPage:pageEntity];
                fp.pageIndex = self.currentPageIndex - 1;
              }
              
            }
        }
        else
        {
            if (self.currentPageController == [self lastPage])   //为后页
            {
                int pageCount = [self.sectionPages count]-1;
                if (self.currentPageIndex < pageCount)  // 还没到最后
                {
                  HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageIndex + 1] path:self.rootPath];
                  if(fp.currentPageEntity == nil || ![fp.currentPageEntity.entityid isEqualToString:pageEntity.entityid]){
                    CGRect lpf = lp.view.frame;
                    lp.view.frame = mp.view.frame;
                    mp.view.frame = fp.view.frame;
                    fp.view.frame = lpf;
                    self.scrollView.contentOffset = CGPointMake(self.currentPageController.view.frame.origin.x, 0);
                    
                    [fp loadPage:pageEntity];
                    fp.pageIndex = self.currentPageIndex +  1;
                  }
                }
            }
        }
    }
}

-(void) resetPageLayout  //重置frame
{
    self.page1Controller.view.frame = CGRectMake(0, 0, self.viewController.view.frame.size.width, self.viewController.view.frame.size.height);
    self.page2Controller.view.frame = CGRectMake(self.viewController.view.frame.size.width, 0, self.viewController.view.frame.size.width, self.viewController.view.frame.size.height);
    self.page3Controller.view.frame = CGRectMake(self.viewController.view.frame.size.width*2, 0, self.viewController.view.frame.size.width, self.viewController.view.frame.size.height);
}

-(void) addFullLayout
{
    HLSliderPageController *fp = [self firstPage];
    HLSliderPageController *mp = [self middlePage];
    HLSliderPageController *lp = [self lastPage];
    if (fp.view.superview == nil)
    {
        [self.scrollView addSubview:fp.view];
    }
    if (mp.view.superview == nil)
    {
        [self.scrollView addSubview:mp.view];
    }
    if (lp.view.superview == nil)
    {
        [self.scrollView addSubview:lp.view];
    }
}

-(void) refreshLayout
{
    //SliderPageController *fp = [self firstPage];
    HLSliderPageController *mp = [self middlePage];
    HLSliderPageController *lp = [self lastPage];
    [self addFullLayout];   //先填满，再进行移除
    if ([self.sectionPages count] >= 3)  //至少三页
    {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
    }
    else  //否则根据总页数确定
    {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * ([self.sectionPages count]), self.scrollView.frame.size.height);
        if ([self.sectionPages count] < 3) //移除最后page
        {
            [lp.view removeFromSuperview];
        }
        if ([self.sectionPages count] < 2) //移除中间page
        {
            [mp.view removeFromSuperview];
        }
    }
}

#pragma mark -
#pragma mark - Load Page
-(void) loadPage:(int) index
{
    if (self.navView != nil)
    {
        [self.navView popdown];
    }
    self.currentPageIndex = index;
    [self loadPages];
}

-(void) loadPages
{
    if (self.currentPageIndex == 0)
    {
        [self resetPageLayout];
        HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageIndex] path:self.rootPath] ;
        [self.controlPanelViewController refreshPanel:self.currentPageIndex count:[self.sectionPages count] enableNav:pageEntity.enbableNavigation];
        [self.page1Controller loadPage:pageEntity];
        self.page1Controller.pageIndex = self.currentPageIndex;
        
        
        if ([self.sectionPages count] >= 2)
        {
            HLPageEntity *pageEnity2 = [HLPageDecoder decode:[self.sectionPages objectAtIndex:(self.currentPageIndex+1)] path:self.rootPath] ;
            [self.page2Controller loadPage:pageEnity2];
            self.page2Controller.pageIndex = self.currentPageIndex + 1;
        }
        self.currentPageController = self.page1Controller;
        
        NSString *pageId = ((HLSliderPageController *)self.currentPageController).currentPageEntity.entityid;
        [_goBackArray addObject:pageId];//adward
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PAGECHANGE object:pageId];//2013.04.22
    }
}




-(void) beginViewCurrent
{
    //    [self.currentPageController beginView];
    self.isBusy = NO;
    self.page1Controller.view.userInteractionEnabled = YES;
    self.page2Controller.view.userInteractionEnabled = YES;
    self.page3Controller.view.userInteractionEnabled = YES;
}



-(void) nextPage
{
    if ((self.currentPageIndex+1) < [self.sectionPages count])
    {
        [self gotoPage:self.currentPageIndex+1 animate:YES];
    }
}

-(void) prePage
{
    if ((self.currentPageIndex-1) >= 0)
    {
        [self gotoPage:self.currentPageIndex-1 animate:YES];
    }
}

#pragma mark -
#pragma mark - Other
- (void)setScrollVIewEnabled:(NSNotification *)notification
{
    BOOL enabled = [notification.object boolValue];
    self.scrollView.scrollEnabled = enabled;
}





-(void) setAutoPlay:(Boolean) value
{
    _isAutoPlay = value;
    
    HLSliderPageController *fp = [self firstPage];
    HLSliderPageController *mp = [self middlePage];
    HLSliderPageController *lp = [self lastPage];
    
    fp.page1Controller.isAutoPlay = _isAutoPlay;
    mp.page1Controller.isAutoPlay = _isAutoPlay;
    lp.page1Controller.isAutoPlay = _isAutoPlay;
}

-(void) homePage
{
    if (self.bookEntity.isVerHorMode == YES)
    {
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if ((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        {
            HLPageEntity *pgEntity  = [[HLPageDecoder decode:self.bookEntity.homepageid path:self.rootPath] retain];
            if (pgEntity.linkPageID != nil)
            {
                if ([pgEntity.linkPageID length] > 0 )
                {
                    [self gotoPageWithPageID:pgEntity.linkPageID animate:YES];
                }
            }
            [pgEntity release];
            return;
        }
    }
    [self gotoPageWithPageID:self.bookEntity.homepageid animate:YES];
}



- (void)animationBegin
{
    
}

- (void)animationEnd
{
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
}








-(void) onNav
{
    if(self.navView.isPoped)
    {
        [self.navView popdown];
    }
    else
    {
        [self.navView popup];
    }
}



-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    self.isOrientation = [self.currentPageController checkOrientation:interfaceOrientation];//2013.04.22
    self.isVerticalPageType = self.currentPageController.currentPageEntity.isVerticalPageType;
    return self.isOrientation;
}

-(void) changeToOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    Boolean isVertical = NO;
    if ((interfaceOrientation  == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        isVertical = YES;
    }
    else
    {
        isVertical = NO;
    }
    self.navView.hidden = YES;
    [self.navView popdown];
    if (isVertical == YES)
    {
        [self.navView changeToVertical];
    }
    else
    {
        [self.navView changeToHorizontal];
    }
    NSLog(@"%@",[self.currentPageController.currentPageEntity.linkPageID class]);
    if(self.currentPageController.currentPageEntity.linkPageID != nil && (![self.currentPageController.currentPageEntity.linkPageID isKindOfClass:[NSNull class]] && ![self.currentPageController.currentPageEntity.linkPageID isEqualToString:@""]))
    {
        if (self.currentPageController.currentPageEntity.isVerticalPageType != isVertical)
        {
            HLSliderPageController *fp = [self firstPage];
            HLSliderPageController *mp = [self middlePage];
            HLSliderPageController *lp = [self lastPage];
            HLPageEntity *entity  = [HLPageDecoder decode:self.currentPageController.currentPageEntity.linkPageID path:self.rootPath];
            self.viewController.view.frame = CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue]);
            self.scrollView.frame = CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue]);
            self.scrollView.contentSize   = CGSizeMake(self.viewController.view.frame.size.width*3, self.viewController.view.frame.size.height);
            fp.view.frame = CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue]);
            mp.view.frame = CGRectMake([entity.width floatValue], 0, [entity.width floatValue], [entity.height floatValue]);
            lp.view.frame = CGRectMake([entity.width floatValue]*2, 0, [entity.width floatValue], [entity.height floatValue]);
            [self.page2Controller changeSize:CGSizeMake([entity.width floatValue], [entity.height floatValue])];
            [self.page3Controller changeSize:CGSizeMake([entity.width floatValue], [entity.height floatValue])];
            [self.page1Controller changeSize:CGSizeMake([entity.width floatValue], [entity.height floatValue])];
            [self gotoPageWithPageID:self.currentPageController.currentPageEntity.linkPageID animate:NO];
        }
    }
}

-(void) goToPageEnableAction
{
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    self.scrollView.scrollEnabled = YES;
    self.scrollView.scrollEnabled = self.currentPageController.currentPageEntity.enbableNavigation;
    self.page1Controller.view.userInteractionEnabled = YES;
    self.page2Controller.view.userInteractionEnabled = YES;
    self.page3Controller.view.userInteractionEnabled = YES;
}

-(void) goToPageDisableAction
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.scrollView.scrollEnabled = NO;
    self.page1Controller.view.userInteractionEnabled = NO;
    self.page2Controller.view.userInteractionEnabled = NO;
    self.page3Controller.view.userInteractionEnabled = NO;
}

-(void) enableAction
{
    self.scrollView.userInteractionEnabled           = YES;
    self.page1Controller.view.userInteractionEnabled = YES;
    self.page2Controller.view.userInteractionEnabled = YES;
    self.page3Controller.view.userInteractionEnabled = YES;
}

-(void) disableAction
{
    self.scrollView.userInteractionEnabled           = NO;
    self.page1Controller.view.userInteractionEnabled = NO;
    self.page2Controller.view.userInteractionEnabled = NO;
    self.page3Controller.view.userInteractionEnabled = NO;
}

-(void)close//adward 3.5
{
    if (self.backgroundMusic != nil)
    {
        [self.backgroundMusic stop];
    }
    //    [self.pageController clean];
    [self.currentPageController clean];
    [self.coverController close];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationScrollEnabled" object:nil];
    [sliderContainerController release];
    [self.page1Controller.view removeFromSuperview];
    [self.page2Controller.view removeFromSuperview];
    [self.page3Controller.view removeFromSuperview];
    [self.page1Controller release];
    [self.page2Controller release];
    [self.page3Controller release];
    [self.scrollView removeFromSuperview];
    [self.scrollView release];
    [self.subpageid release];
    [self.goBackArray removeAllObjects];    //陈星宇，10.28，slideflip
    [self.goBackArray  release];
    [super dealloc];
}



@end

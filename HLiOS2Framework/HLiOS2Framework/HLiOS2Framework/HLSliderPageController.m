//
//  SliderPageController.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-12-31.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLSliderPageController.h"
#import "HLPageDecoder.h"

#define KNOTIFICATION_SUBPAGECHANGE     @"SliderPageSubPageChange"
#define KNOTIFICATION_PAGEVIEWTAP       @"PageViewTap"

@interface HLSliderPageController ()

{
    HLPageEntity *gotoPageEntity;
}

@end

@implementation HLSliderPageController

@synthesize page1Controller;
@synthesize page2Controller;
@synthesize page3Controller;
@synthesize pageScrollView;
@synthesize behController;
@synthesize currentPageEntity;
@synthesize currentPageController;
@synthesize rootPath;
@synthesize pageIndex;
@synthesize subPageIndex;
@synthesize isBusy;


#pragma mark -
#pragma mark - init Method


- (id)init
{
    self = [super init];
    if (self)
    {
        if (self.page1Controller == nil)
        {
//            self.page1Controller = [[[PageController alloc] init] autorelease];   //10.30
            self.page1Controller = [[HLPageController alloc] init];
            [page1Controller release];
        }
        if (self.page2Controller == nil)
        {
//            self.page2Controller = [[[PageController alloc] init] autorelease];
            self.page2Controller = [[HLPageController alloc] init];
            [page2Controller release];
        }
        if (self.page3Controller == nil)
        {
//            self.page3Controller = [[[PageController alloc] init] autorelease];
            self.page3Controller = [[HLPageController alloc] init];
            [page3Controller release];
        }
        if (self.pageScrollView == nil)
        {
//            self.pageScrollView = [[[UIScrollView alloc] init] autorelease];
            self.pageScrollView = [[UIScrollView alloc] init];
            [pageScrollView release];
        }
        self.pageIndex = -1;
        self.isBusy    = NO;
        
        sliderContainerController = [[HLSliderPageContainerController alloc] init];
        
        //      >>>>>
        changeUpCover = NO;
        changeDownCover = NO;
        endDecelerate = YES;
        isGotoPage = NO;
        //      <<<<<
    }
    return self;
}

-(void) setup:(CGRect) rect
{
    self.pageScrollView.frame         = CGRectMake(0, 0, rect.size.width, rect.size.height);
    self.pageScrollView.contentSize   = CGSizeMake(rect.size.width, rect.size.height*3);
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.pageScrollView.delegate      = self;
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    self.pageScrollView.showsVerticalScrollIndicator   = NO;
    
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap)] autorelease];
    tapGesture.delegate = self;
    [self.pageScrollView addGestureRecognizer:tapGesture];
    
    [self.page1Controller setup:rect];
    self.page1Controller.pageViewController.view.frame  = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [self.page2Controller setup:rect];
    self.page2Controller.pageViewController.view.frame  = CGRectMake(0, rect.size.height, rect.size.width, rect.size.height);
    [self.page3Controller setup:rect];
    self.page3Controller.pageViewController.view.frame  = CGRectMake(0, rect.size.height*2, rect.size.width, rect.size.height);
    [self.view addSubview:self.pageScrollView];
    
    //陈星宇，10.30，泄漏部分
    [self.pageScrollView addSubview:self.page1Controller.pageViewController.view];
    [self.pageScrollView addSubview:self.page2Controller.pageViewController.view];
    [self.pageScrollView addSubview:self.page3Controller.pageViewController.view];
    self.page1Controller.behaviorController = self.behController;
    self.page2Controller.behaviorController = self.behController;
    self.page3Controller.behaviorController = self.behController;
    self.page1Controller.bookEntity = self.bookEntity;
    self.page2Controller.bookEntity = self.bookEntity;
    self.page3Controller.bookEntity = self.bookEntity;
}

-(void) setupRootPath:(NSString *) path
{
    self.page1Controller.rootPath = path;
    self.page2Controller.rootPath = path;
    self.page3Controller.rootPath = path;
}

#pragma mark -
#pragma mark - Change Cover
- (BOOL)changeCover:(relativeDirection)direction
{
    //      >>>>> 1.3
    NSString *curBecoverID =  self.coverPageController.currentCoverPageid;  //done
    
    NSString *CompareBecoverID = nil;
    HLPageEntity *pageEntity = nil;
    
    int pageCount = [self.currentPageEntity.navPages count] - 1;    //总子页数, >= 0
    
    switch (direction)
    {
        case relativeDirectionDown:
        {
            if (isGotoPage == NO) //手动翻页
            {
                if (self.subPageIndex == pageCount)
                {
                    return NO;
                }
                
                if (self.subPageIndex + 1 <= pageCount && self.subPageIndex >= -1)
                {
                    pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:(self.subPageIndex + 1)] path:self.rootPath];
                }
            }
            else //跳转翻页
            {
                if (self.subPageIndex <= pageCount)
                {
                    pageEntity = gotoPageEntity;
                }
            }
        }
            break;
            
        case relativeDirectionUp:   //上方cover
        {
            if (isGotoPage == NO)   //手动翻页
            {
                if (self.subPageIndex == -1)
                {
                    return NO;
                }
                
                if (-1 <= self.subPageIndex - 1  &&  self.subPageIndex - 1 < pageCount)
                {
                    if ( -1 == self.subPageIndex - 1)
                    {
                        pageEntity = self.currentPageEntity;
                    }
                    else
                    {
                        pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:self.subPageIndex - 1] path:self.rootPath];
                    }
                }
            }
            else    //跳转翻页
            {
                
                if (self.subPageIndex >= -1 && self.subPageIndex <= pageCount)
                {
                    
                        pageEntity = gotoPageEntity;
                    
                }
            }
        }
            break;
            
            default:
            break;
    }
    
    CompareBecoverID = pageEntity.beCoveredPageID;
//    NSLog(@"curBecoverID = %@ :: CompareBecoverID = %@ ",self.coverPageController.currentCoverPageid,CompareBecoverID);
    
    if (curBecoverID == nil)
    {
        curBecoverID = @"";
    }
    if (CompareBecoverID == nil)
    {
        CompareBecoverID = @"";
    }
    
    NSLog(@"CompareBecoverID = %@",CompareBecoverID);
    NSLog(@"curBecoverID = %@",curBecoverID);
    
    if ([curBecoverID isEqualToString:CompareBecoverID])
    {
        return NO;
    }
    else
    {
        //        if (CompareBecoverID != nil && ![@"" isEqualToString:CompareBecoverID])
        //        {
        switch (direction)
        {
            case relativeDirectionDown:
            {
                [self.coverPageController loadCoverPageEntity:pageEntity direction:relativeDirectionDown];
            }
                break;
                
            case relativeDirectionUp:
            {
                [self.coverPageController loadCoverPageEntity:pageEntity direction:relativeDirectionUp];
            }
                break;
                //            }
                
                default:
                break;
        }
        
        
        return YES;
    }
    //      <<<<<
}


#pragma mark -
#pragma mark - scrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    if (isGotoPage) {
        return;
    }
    
    sliderContainerController.beginDragY = self.pageScrollView.contentOffset.y;
    sliderContainerController.isInitPos = NO;
    sliderContainerController.scrollSpace = self.pageScrollView.frame.size.height;
    
    //      >>>>>
    currentUpBound = self.pageScrollView.contentOffset;
    currentDownBound = CGPointMake(self.pageScrollView.contentOffset.x, self.pageScrollView.contentOffset.y + self.pageScrollView.frame.size.height);
    endDecelerate = NO; //1.3
    changeUpCover = NO;
    changeDownCover = NO;
    changeUpCover = [self changeCover:relativeDirectionUp];
    changeDownCover  =  [self changeCover:relativeDirectionDown];
    NSLog(@" up = %d , down = %d",changeUpCover , changeDownCover);
    [self.coverPageController scrollViewWillBeginDragging:self.pageScrollView];
    
    //      <<<<<
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.pageScrollView.scrollEnabled = NO;
    //  >>>>> Mr.chen,1.14
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    self.pageScrollView.scrollEnabled = NO;
//    self.page1Controller.pageViewController.view.userInteractionEnabled = NO;
//    self.page2Controller.pageViewController.view.userInteractionEnabled = NO;
//    self.page3Controller.pageViewController.view.userInteractionEnabled = NO;
    //    <<<<<
    
    //      >>>>>
    [self.coverPageController scrollViewWillBeginDecelerating:self.pageScrollView];
    //      <<<<<
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    >>>>>
    if (isGotoPage)
    {
        [self goToPageDisableAction];
    }
//    <<<<<
    
    sliderContainerController.page1Controller = [self firstPage];
    sliderContainerController.page2Controller = [self middlePage];
    sliderContainerController.page3Controller = [self lastPage];
    sliderContainerController.curPageController = self.currentPageController;
    [sliderContainerController scrollViewDidScroll:self.pageScrollView];
    
    //      >>>>> 1.2
    if (endDecelerate == NO)
    {
        if (changeDownCover == YES ) 
        {
            if (changeUpCover == NO)    //有下无上
            {
                
                if (self.pageScrollView.contentOffset.y + self.pageScrollView.frame.size.height - currentDownBound.y >= 0.000)
                {
                    [self.coverPageController scrollViewDidScroll:self.pageScrollView]; //1.3
                }
            }
            else            //有下有上
            {
                [self.coverPageController scrollViewDidScroll:self.pageScrollView]; //1.3
            }
            
        }
        else
        {
            if (changeUpCover == NO)        //无下无上
            {
                
                
            }
            else            // 无下有上
            {
                if (self.pageScrollView.contentOffset.y - currentUpBound.y <= 0.000)
                {
                    [self.coverPageController scrollViewDidScroll:self.pageScrollView]; //1.3
                }
            }
        }
    }
    //      <<<<<
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //      >>>>>
    isGotoPage = NO;
    endDecelerate = YES;
//    [self goToPageEnableAction];
    [self.coverPageController scrollViewDidEndDecelerating:self.pageScrollView];
    //      <<<<<
    
    self.pageScrollView.scrollEnabled = YES;
    if ([self searchCurrentPage] == self.currentPageController)
    {
        
    }
    else
    {
        [self.currentPageController clean];
        self.currentPageController = [self searchCurrentPage];//必要步骤1/3
//        if(self.currentPageController.currentPageEntity == nil)
//        {
//            if(self.subPageIndex == -1)
//            {
//                HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:0] path:self.rootPath];
//                [self.currentPageController loadEntity:pageEntity];   //必要步骤2/3
//            }
//            else
//            {
//                HLPageController *fp = [self firstPage];
//                HLPageController *lp = [self lastPage];
//                if(self.currentPageController == fp)
//                {
//                    if(self.subPageIndex > 0 )
//                    {
//                        HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:self.subPageIndex - 1] path:self.rootPath];
//                        [self.currentPageController loadEntity:pageEntity];   //必要步骤2/3
//                    }
//                    else
//                    {
//                        [self.currentPageController loadEntity:self.currentPageEntity];   //必要步骤2/3
//                    }
//                }
//                else if(self.currentPageController == lp)
//                {
//                    if(self.subPageIndex < self.currentPageEntity.navPages.count)
//                    {
//                        HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:self.subPageIndex + 1] path:self.rootPath];
//                        [self.currentPageController loadEntity:pageEntity];   //必要步骤2/3
//                    }
//                }
//            }
//        }
        

        [UIAccelerometer sharedAccelerometer].delegate = self.currentPageController.pageViewController;
        self.subPageIndex          = [self searchSubPageIndex:self.currentPageController.currentPageEntity.entityid];       //当前子页
        [self arrangePage];
        
        self.behController.pageController = self.currentPageController;
        self.currentPageController.behaviorController = self.behController;
        
        NSArray<HLPageController *> *pages = @[page1Controller, page2Controller, page3Controller];
        for (NSUInteger i = 0; i < 3; i++) {
            HLPageController *p = [pages objectAtIndex:i];
            if ( p != currentPageController) {
                [p stopView];
            }
        }
        
        
        [self.currentPageController beginView];                                                 //必要步骤3/3

        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SUBPAGECHANGE object:[NSNumber numberWithInt:self.subPageIndex]];
    }
    [self performSelector:@selector(beginViewCurrent) withObject:nil afterDelay:0.05];
}

#pragma mark -
#pragma mark - Go to Page
-(Boolean) gotoPageWithPageID:(NSString *)pageid animate:(Boolean)animate;
{
    int index = [self searchSubPageIndex:pageid];
    if (index == -2)
    {
        return NO;
    }
    
    if (self.isBusy == YES)
    {
        return YES;
    }
    
    
    isGotoPage = YES;
    endDecelerate = NO; //Mr.chen , 2.11
    changeUpCover = NO;
    changeDownCover = NO;
    
    HLPageController *fp = [self firstPage];
    HLPageController *mp = [self middlePage];
    HLPageController *lp = [self lastPage];
    
    if(index != self.subPageIndex)
    {
        
        self.isBusy = YES;
        if (index > self.subPageIndex)
        {
            if (self.currentPageController == fp)
            {
                int pageCout = [self.currentPageEntity.navPages count];
                if (index < pageCout)
                {
                    gotoPageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:index] path:self.rootPath];
                    [mp clean];
                    [mp loadEntity:gotoPageEntity];
                    self.subPageIndex  = index;
                    
                    //      >>>>>
                    currentUpBound = self.pageScrollView.contentOffset;
                    currentDownBound = CGPointMake(self.pageScrollView.contentOffset.x , self.pageScrollView.contentOffset.y + CGRectGetHeight(self.pageScrollView.frame));
                    
                    changeDownCover = [self changeCover:relativeDirectionDown]; //Mr.chen , 2.11
                    
                    [(HLSliderCoverPageController *)self.coverPageController scrollViewBeginGoToPage:self.pageScrollView];

                    //      <<<<<
                    
                    [self.pageScrollView setContentOffset:CGPointMake(0, mp.pageViewController.view.frame.origin.y) animated:animate];      //向上走
                }
                else
                {
                    CGRect fpr = fp.pageViewController.view.frame;
                    fp.pageViewController.view.frame = mp.pageViewController.view.frame;
                    mp.pageViewController.view.frame = fpr;
                    
                    [self.pageScrollView setContentOffset:CGPointMake(fp.pageViewController.view.frame.origin.x, fp.pageViewController.view.frame.origin.y)];
                    self.isBusy = NO;
                    [self gotoPageWithPageID:pageid animate:animate];
                }
            }
            else
            {
                if(self.currentPageController == mp)
                {
                    gotoPageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:index] path:self.rootPath];
                    [lp clean];
                    [lp loadEntity:gotoPageEntity];
                    self.subPageIndex = index;
                    
                    //      >>>>>
                    currentUpBound = self.pageScrollView.contentOffset;
                    currentDownBound = CGPointMake(self.pageScrollView.contentOffset.x , self.pageScrollView.contentOffset.y + CGRectGetHeight(self.pageScrollView.frame));
                    
                    changeDownCover = [self changeCover:relativeDirectionDown]; //Mr.chen , 2.11
                    [(HLSliderCoverPageController *)self.coverPageController scrollViewBeginGoToPage:self.pageScrollView];
                    //      <<<<<
                    
                    [self.pageScrollView setContentOffset:CGPointMake(0, lp.pageViewController.view.frame.origin.y) animated:animate];      //向上走
                }
            }
        }
        else
        {
            if (index < self.subPageIndex)
            {
                if (self.currentPageController == mp)
                {
                    if (index >= 0)
                    {
                        gotoPageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:index] path:self.rootPath];
                        [fp clean];
                        [fp loadEntity:gotoPageEntity];
                        self.subPageIndex  = index;
                        
                        //      >>>>>
                        currentUpBound = self.pageScrollView.contentOffset;
                        currentDownBound = CGPointMake(self.pageScrollView.contentOffset.x , self.pageScrollView.contentOffset.y + CGRectGetHeight(self.pageScrollView.frame));
                        
                        changeUpCover = [self changeCover:relativeDirectionUp]; //Mr.chen , 2.11
                        [(HLSliderCoverPageController *)self.coverPageController scrollViewBeginGoToPage:self.pageScrollView];
                        //      <<<<<
                        
                        [self.pageScrollView setContentOffset:CGPointMake(0, fp.pageViewController.view.frame.origin.y) animated:animate];
                    }
                    else    //index == -1;
                    {
                        gotoPageEntity = self.currentPageEntity;
                        [fp clean];
                        [fp loadEntity:gotoPageEntity];
                        self.subPageIndex = index;
                        
                        //      >>>>>
                        currentUpBound = self.pageScrollView.contentOffset;
                        currentDownBound = CGPointMake(self.pageScrollView.contentOffset.x , self.pageScrollView.contentOffset.y + CGRectGetHeight(self.pageScrollView.frame));
                        
                        changeUpCover = [self changeCover:relativeDirectionUp];  //Mr.chen , 2.11
                        [(HLSliderCoverPageController *)self.coverPageController scrollViewBeginGoToPage:self.pageScrollView];
                        //      <<<<<
                        
                        [self.pageScrollView setContentOffset:CGPointMake(0, fp.pageViewController.view.frame.origin.y) animated:animate];
                    }
                }
                else   //向下滚动
                {
                    if (self.currentPageController == lp)
                    {
                        if (index >= 0)
                        {
                            gotoPageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:index] path:self.rootPath];
                            [mp clean];
                            [mp loadEntity:gotoPageEntity];
                            self.subPageIndex = index;
                            
                            //      >>>>>
                            currentUpBound = self.pageScrollView.contentOffset;
                            currentDownBound = CGPointMake(self.pageScrollView.contentOffset.x , self.pageScrollView.contentOffset.y + CGRectGetHeight(self.pageScrollView.frame));
                            
                            changeUpCover = [self changeCover:relativeDirectionUp];  //Mr.chen , 2.11
                            [(HLSliderCoverPageController *)self.coverPageController scrollViewBeginGoToPage:self.pageScrollView];
                            //      <<<<<
                            
                            [self.pageScrollView setContentOffset:CGPointMake(0, mp.pageViewController.view.frame.origin.y) animated:animate];
                        }
                        else
                        {
                            CGRect lpr = lp.pageViewController.view.frame;
                            lp.pageViewController.view.frame = mp.pageViewController.view.frame;
                            mp.pageViewController.view.frame = lpr;
                            [self.pageScrollView setContentOffset:CGPointMake(lp.pageViewController.view.frame.origin.x, lp.pageViewController.view.frame.origin.y)];
                            
                            self.isBusy = NO;
                            [self gotoPageWithPageID:pageid animate:animate];
                        }
                    }
                }
            }
        }
    }
    else
    {
        isGotoPage = NO;
    }
    
    if (animate == NO)
    {
        [self scrollViewDidEndScrollingAnimation:self.pageScrollView];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SUBPAGECHANGE object:[NSNumber numberWithInt:self.subPageIndex]];
    
    return YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    
    endDecelerate = YES;
    [self.coverPageController scrollViewDidEndDecelerating:self.pageScrollView];    //Mr.chen , 2.11
    
    if (isGotoPage)
    {
        [self goToPageEnableAction];
    }
    
    HLPageController *fp = [self firstPage];
    HLPageController *mp = [self middlePage];
    HLPageController *lp = [self lastPage];
    self.currentPageController = [self searchCurrentPage];
    [UIAccelerometer sharedAccelerometer].delegate = self.currentPageController.pageViewController;
    if (self.currentPageController == mp)
    {
        
        if (self.subPageIndex == 0)
        {
            [fp clean];
            [fp loadEntity:self.currentPageEntity];
        }
        else
        {
            HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:(self.subPageIndex - 1)] path:self.rootPath];
            [fp clean];
            [fp loadEntity:pageEntity];
        }
        int pageCout = [self.currentPageEntity.navPages count] - 1;
        if (self.subPageIndex < pageCout)
        {
            HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:self.subPageIndex + 1] path:self.rootPath];
            [lp clean];
            [lp loadEntity:pageEntity];
        }
        else
        {
            if ((self.subPageIndex == pageCout) && (pageCout >= 1))
            {
                CGRect lpr = lp.pageViewController.view.frame;
                lp.pageViewController.view.frame = mp.pageViewController.view.frame;
                mp.pageViewController.view.frame = lpr;
                [self.pageScrollView setContentOffset:CGPointMake(mp.pageViewController.view.frame.origin.x, mp.pageViewController.view.frame.origin.y)];
                [self scrollViewDidEndScrollingAnimation:self.pageScrollView];
                return;
            }
        }
    }
    else
    {
        if (self.currentPageController == lp)
        {
            if (self.subPageIndex == 0)
            {
                [mp clean];
                [mp loadEntity:self.currentPageEntity];
            }
            else
            {
                if (self.subPageIndex > 0)
                {
                    HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:(self.subPageIndex - 1)] path:self.rootPath];
                    [mp clean];
                    [mp loadEntity:pageEntity];
                }
            }
            [self arrangePage];
        }
        else
        {
            if (self.currentPageController == fp)
            {
                int pageCout = [self.currentPageEntity.navPages count] - 1;
                if (self.subPageIndex < pageCout)
                {
                    HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:self.subPageIndex + 1] path:self.rootPath];
                    [mp clean];
                    [mp loadEntity:pageEntity];
                }
                [self arrangePage];
            }
        }
    }
    self.isBusy = NO;
    isGotoPage = NO;
    
    self.behController.pageController = self.currentPageController;
    [self.currentPageController beginView];
    
    [self goToPageEnableAction];
}

#pragma mark -
#pragma mark - get Page
/**
 *  get the subPageIndex by searching pageid.
 *
 *  @param pageid the page`d id.
 *
 *  @return if the pageid is in 'NavPages' ,return 1 ~ (n-1); if the pageid is current page`s id , return -1 ; else return -2.
 */
-(int) searchSubPageIndex:(NSString *) pageid
{
    for (int i = 0 ; i < [self.currentPageEntity.navPages count]; i++)
    {
        if([pageid isEqualToString:[self.currentPageEntity.navPages objectAtIndex:i]])
        {
            return i;
        }
    }
    if ([pageid isEqualToString:self.currentPageEntity.entityid] == YES)
    {
        return -1;
    }
    return -2;
}

-(HLPageController *) searchCurrentPage
{
    float dy   = self.pageScrollView.contentOffset.y;
    float p1dy = self.page1Controller.pageViewController.view.frame.origin.y+self.page1Controller.pageViewController.view.frame.size.height;
    float p2dy = self.page2Controller.pageViewController.view.frame.origin.y+self.page1Controller.pageViewController.view.frame.size.height;
    if ((dy >= self.page1Controller.pageViewController.view.frame.origin.y) && (dy < p1dy))
    {
        return self.page1Controller;
    }
    else
    {
        if ((dy >= self.page2Controller.pageViewController.view.frame.origin.y) && (dy < p2dy))
        {
            return self.page2Controller;
        }
        else
        {
            return self.page3Controller;
        }
    }
}

-(HLPageController *) firstPage
{
    float p1dy = self.page1Controller.pageViewController.view.frame.origin.y;
    float p2dy = self.page2Controller.pageViewController.view.frame.origin.y;
    if (p1dy == 0)
    {
        return self.page1Controller;
    }
    else
    {
        if (p2dy == 0)
        {
            return self.page2Controller;
        }
        else
        {
            return self.page3Controller;
        }
    }
}

-(HLPageController *) middlePage
{
    float p1dy = self.page1Controller.pageViewController.view.frame.origin.y;
    float p2dy = self.page2Controller.pageViewController.view.frame.origin.y;
    if (p1dy == self.pageScrollView.frame.size.height)
    {
        return self.page1Controller;
    }
    else
    {
        if (p2dy == self.pageScrollView.frame.size.height)
        {
            return self.page2Controller;
        }
        else
        {
            return self.page3Controller;
        }
    }
}

-(HLPageController *) lastPage
{
    float p1dy = self.page1Controller.pageViewController.view.frame.origin.y;
    float p2dy = self.page2Controller.pageViewController.view.frame.origin.y;
    if (p1dy == self.pageScrollView.frame.size.height*2)
    {
        return self.page1Controller;
    }
    else
    {
        if (p2dy == self.pageScrollView.frame.size.height*2)
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
-(void) beginView
{
    //[self refreshContent];
    self.behController.pageController = self.page1Controller;       //Mr.chen , 1.20 , 放在这里
    [self.page1Controller beginView];
//    self.behController.pageController = self.page1Controller;     //Mr.chen , 1.20 , 不要放在这里
    
    
    //关闭导航的设置
    if (self.sliderFlipController.currentPageController == self)
    {
        if (self.currentPageEntity.enableGesture == YES)
        {
            self.sliderFlipController.canScroll = YES;
            self.sliderFlipController.scrollView.scrollEnabled = YES;
        }
        else
        {
            self.sliderFlipController.canScroll = NO;
            self.sliderFlipController.scrollView.scrollEnabled = NO;
        }
        if (!self.currentPageEntity.enbableNavigation)
        {
            self.sliderFlipController.canScroll = NO;
            self.sliderFlipController.scrollView.scrollEnabled = NO;
        }
    }
    
//    [self.page1Controller beginView];
}

-(void) clean
{
  self.isBusy = NO;
  [self.page1Controller clean];
  [self.page2Controller clean];
  [self.page3Controller clean];
}

-(void) arrangePage
{
    HLPageController *fp = [self firstPage];
    HLPageController *mp = [self middlePage];
    HLPageController *lp = [self lastPage];
    if (self.currentPageController == [self firstPage])
    {
        if (self.subPageIndex > 0 )
        {
            CGRect fpf    =  fp.pageViewController.view.frame;
            fp.pageViewController.view.frame =  mp.pageViewController.view.frame;
            mp.pageViewController.view.frame =  lp.pageViewController.view.frame;
            lp.pageViewController.view.frame = fpf;
            self.pageScrollView.contentOffset = CGPointMake(0, self.currentPageController.pageViewController.view.frame.origin.y);
            HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:self.subPageIndex - 1] path:self.rootPath];
            [lp clean];
            [lp loadEntity:pageEntity];
            
            [mp clean];
            if(self.subPageIndex < [self.currentPageEntity.navPages count] - 1)
            {
                HLPageEntity *pageEntity1 = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:self.subPageIndex + 1] path:self.rootPath];
                [mp loadEntity:pageEntity1];
            }
        }
        else
        {
            if (self.subPageIndex == 0)
            {
                CGRect fpf    =  fp.pageViewController.view.frame;
                fp.pageViewController.view.frame =  mp.pageViewController.view.frame;
                mp.pageViewController.view.frame =  lp.pageViewController.view.frame;
                lp.pageViewController.view.frame = fpf;
                self.pageScrollView.contentOffset = CGPointMake(0, self.currentPageController.pageViewController.view.frame.origin.y);
                [lp clean];
                [lp loadEntity:self.currentPageEntity];
                [mp clean];
                if(self.subPageIndex < [self.currentPageEntity.navPages count] - 1)
                {
                    HLPageEntity *pageEntity1 = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:self.subPageIndex + 1] path:self.rootPath];
                    [mp loadEntity:pageEntity1];
                }
            }
            else
            {
                if([self.currentPageEntity.navPages count] > 0)
                {
                    HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:0] path:self.rootPath];
                    [mp clean];
                    [mp loadEntity:pageEntity];
                }
            }
        }
    }
    else
    {
        if (self.currentPageController == [self middlePage])
        {
            int pageCount = [self.currentPageEntity.navPages count]-1;
            if (self.subPageIndex < pageCount)
            {
                HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:self.subPageIndex + 1] path:self.rootPath];
                [lp clean];
                [lp loadEntity:pageEntity];
            }
            else
            {
                
            }
            if (self.subPageIndex > 0)
            {
                HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:self.subPageIndex - 1] path:self.rootPath];
                [fp clean];
                [fp loadEntity:pageEntity];
            }
            else
            {
                if (self.subPageIndex == 0)
                {
                    [fp clean];
                    [fp loadEntity:self.currentPageEntity];
                }
            }
            
        }
        else
        {
            if (self.currentPageController == [self lastPage])
            {
                int pageCount = [self.currentPageEntity.navPages count]-1;
                if (self.subPageIndex < pageCount)
                {
                    CGRect lpf = lp.pageViewController.view.frame;
                    lp.pageViewController.view.frame = mp.pageViewController.view.frame;
                    mp.pageViewController.view.frame = fp.pageViewController.view.frame;
                    fp.pageViewController.view.frame = lpf;
                    self.pageScrollView.contentOffset = CGPointMake(0, self.currentPageController.pageViewController.view.frame.origin.y);
                    HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:self.subPageIndex + 1] path:self.rootPath];
                    [fp clean];
                    [fp loadEntity:pageEntity];
                }
                
                if (self.subPageIndex > 0)
                {
                    HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:self.subPageIndex - 1] path:self.rootPath];
                    [mp clean];
                    [mp loadEntity:pageEntity];
                }
                else
                {
                    if (self.subPageIndex == 0)
                    {
                        [mp clean];
                        [mp loadEntity:self.currentPageEntity];
                    }
                }

            }
        }
    }
}

-(void) changeSize:(CGSize) size
{
    HLPageController *fp = [self firstPage];
    HLPageController *mp = [self middlePage];
    HLPageController *lp = [self lastPage];
    self.pageScrollView.frame = CGRectMake(0, 0, size.width, size.height);
    self.pageScrollView.contentSize   = CGSizeMake(size.width, size.height*3);
    fp.pageViewController.view.frame = CGRectMake(0, 0, size.width, size.height);
    mp.pageViewController.view.frame = CGRectMake(0, size.height, size.width, size.height);
    lp.pageViewController.view.frame = CGRectMake(0, size.height*2, size.width, size.height);
}


-(void) refreshLayout
{
    self.pageScrollView.contentOffset = CGPointMake(0, 0);
    self.page1Controller.pageViewController.view.frame = CGRectMake(0, 0, self.pageScrollView.frame.size.width, self.pageScrollView.frame.size.height);
    self.page2Controller.pageViewController.view.frame = CGRectMake(0, self.pageScrollView.frame.size.height, self.pageScrollView.frame.size.width, self.pageScrollView.frame.size.height);
    self.page3Controller.pageViewController.view.frame = CGRectMake(0, self.pageScrollView.frame.size.height*2, self.pageScrollView.frame.size.width, self.pageScrollView.frame.size.height);
}

-(void) refreshContent
{
    if ([self.currentPageEntity.navPages count] >= 1)
    {
        HLPageEntity *pageEntity = [HLPageDecoder decode:[self.currentPageEntity.navPages objectAtIndex:0] path:self.rootPath];
        [self.page2Controller loadEntity:pageEntity];
    }
}

-(void) refreshSize  //根据当前子页数目数量
{
    self.page1Controller.pageViewController.view.hidden = NO;
    self.page2Controller.pageViewController.view.hidden = NO;
    self.page3Controller.pageViewController.view.hidden = NO;
    if ([self.currentPageEntity.navPages count] >= 2)
    {
        self.pageScrollView.contentSize = CGSizeMake(self.pageScrollView.frame.size.width, self.pageScrollView.frame.size.height*3);
    }
    else
    {
        self.pageScrollView.contentSize = CGSizeMake(self.pageScrollView.frame.size.width, self.pageScrollView.frame.size.height*(1+[self.currentPageEntity.navPages count]));
        if ([self.currentPageEntity.navPages count] <= 1)
        {
            self.page3Controller.pageViewController.view.hidden = YES;
        }
        if ([self.currentPageEntity.navPages count] <= 0)
        {
            self.page2Controller.pageViewController.view.hidden = YES;
        }
    }
}


#pragma mark -
#pragma mark - Page Control
-(void) beginViewCurrent
{
    //    [self.currentPageController beginView];
    self.isBusy = NO;
    self.page1Controller.pageViewController.view.userInteractionEnabled = YES;
    self.page2Controller.pageViewController.view.userInteractionEnabled = YES;
    self.page3Controller.pageViewController.view.userInteractionEnabled = YES;
}

-(void) goToPageEnableAction
{
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.pageScrollView.scrollEnabled = YES;
//    self.page1Controller.pageViewController.view.userInteractionEnabled = YES;
//    self.page2Controller.pageViewController.view.userInteractionEnabled = YES;
//    self.page3Controller.pageViewController.view.userInteractionEnabled = YES;
}

-(void) goToPageDisableAction
{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.pageScrollView.scrollEnabled = NO;
//    self.page1Controller.pageViewController.view.userInteractionEnabled = NO;
//    self.page2Controller.pageViewController.view.userInteractionEnabled = NO;
//    self.page3Controller.pageViewController.view.userInteractionEnabled = NO;
}



-(void) loadPage:(HLPageEntity *) pageEntity
{
    //    NSLog(@"loadPage");
    [self clean];
    [self refreshLayout];
    self.currentPageEntity = pageEntity;
    [self refreshSize];
    [self.page1Controller loadEntity:pageEntity];
    self.currentPageController  = self.page1Controller;
    
    [UIAccelerometer sharedAccelerometer].delegate = self.currentPageController.pageViewController;
    self.subPageIndex = -1;
    self.sliderFlipController.isVerticalPageType = self.currentPageController.currentPageEntity.isVerticalPageType;
    [self arrangePage];
    
}

//解决ios5按钮和手势冲突问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if ([touch.view isKindOfClass:[UIButton class]])
        {
            return NO;
        }
    }
    return YES;
}

- (void)scrollViewTap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PAGEVIEWTAP object:nil];
}

-(void) stopView
{
    
}

-(void) reset { // reset the up, mid, down pages to origin, such as, reset audio, video, view, animation etc.
    page1Controller.isBeginView = false;
    page2Controller.isBeginView = false;
    page3Controller.isBeginView = false;
    [page1Controller resetView];
    [page2Controller resetView];
    [page3Controller resetView];
    [page1Controller stopView];
    [page2Controller stopView];
    [page3Controller stopView];
}


-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([self.currentPageEntity.linkPageID length] > 0 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [sliderContainerController release];
//    [self.currentPageEntity release];
    [self.bookEntity release];                                        //陈星宇，11.2
    [self.page1Controller.pageViewController.view removeFromSuperview];
    [self.page1Controller release];
    [self.page2Controller.pageViewController.view removeFromSuperview];
    [self.page2Controller release];
    [self.page3Controller.pageViewController.view removeFromSuperview];
    [self.page3Controller release];
    [self.pageScrollView removeFromSuperview];  //陈星宇，10.30
    [self.pageScrollView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end

//
//  SliderCoverController.m
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 13-12-31.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLSliderCoverController.h"
#import "HLClearScrollView.h"
#import "HLPageController.h"
#import "HLPageViewController.h"
#import "HLSliderFlipController.h"

@implementation HLSliderCoverController

{
    HLPageViewController *curpageViewController;
}

#pragma mark -
#pragma mark - Life Cycle
- (id)init
{
    self = [super init];
    if (self) {
        if (self.page1Controller == nil)
        {
            self.page1Controller = [[HLSliderCoverPageController alloc] init];
        }
        if (self.page2Controller == nil)
        {
            self.page2Controller = [[HLSliderCoverPageController alloc] init];
        }
        if (self.page3Controller == nil)
        {
            self.page3Controller = [[HLSliderCoverPageController alloc] init];
        }

        self.behaviorController = [[HLBehaviorController alloc] init];
        
        self.page1Controller.behaviorContoller = self.behaviorController;
        self.page2Controller.behaviorContoller = self.behaviorController;
        self.page3Controller.behaviorContoller = self.behaviorController;

        containerController = [[HLSliderCoverContainerController alloc] init];
    }
    return self;
}

- (void)setup:(CGRect)rect
{
    self.viewController = [[HLCoverBaseViewController alloc] init];
    self.viewController.view.frame = rect;
    self.viewController.coverController = self;
    self.viewController.view.backgroundColor = [UIColor clearColor];
    sliderFlipController = (HLSliderFlipController *)self.flipController;
    
    clearScrollView  =  ((HLClearScrollView *)self.viewController.view);
    clearScrollView.contentSize = CGSizeMake(rect.size.width * 3, rect.size.height);
    clearScrollView.contentOffset = CGPointMake(rect.size.width * 1, rect.origin.y);

    [self.page1Controller setupRootPath:self.rootPath];
    [self.page2Controller setupRootPath:self.rootPath];
    [self.page3Controller setupRootPath:self.rootPath];
    
    self.page1Controller.behaviorContoller.flipController = self.behaviorController.flipController;
    self.page2Controller.behaviorContoller.flipController = self.behaviorController.flipController;
    self.page3Controller.behaviorContoller.flipController = self.behaviorController.flipController;
    
    [self.page1Controller setup:CGRectMake( rect.size.width * 0, 0, rect.size.width, rect.size.height)];
    [self.page2Controller setup:CGRectMake( rect.size.width * 1, 0, rect.size.width, rect.size.height)];
    [self.page3Controller setup:CGRectMake( rect.size.width * 2, 0, rect.size.width, rect.size.height)];

    [self.viewController.view addSubview:self.page1Controller.view];
    [self.viewController.view addSubview:self.page2Controller.view];
    [self.viewController.view addSubview:self.page3Controller.view];
    
    self.currentPageController = self.page2Controller;
    self.behaviorController.pageController = self.currentPageController.currentCoverController;
}

- (void)initEntity:(HLPageEntity *)pageEntity
{
    self.currentPageid = pageEntity.beCoveredPageID;
    HLPageEntity *coverPageEntity = [HLPageDecoder decode:self.currentPageid path:self.flipController.bookEntity.rootPath];
//    [self.currentPageController.currentCoverController clean];
    [self.currentPageController initEntity:coverPageEntity];
}

- (void)close
{
    [self.currentPageController clean];
}

- (void)clean
{
    
}

#pragma mark -
#pragma mark - drag page

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    containerController.beginDragX = scrollView.contentOffset.x;
    containerController.isInitPos = NO;
    containerController.scrollSpace = scrollView.frame.size.width;
    containerController.dragingX = scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self disableAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    clearScrollView.contentOffset = CGPointMake(clearScrollView.contentOffset.x + scrollView.contentOffset.x - containerController.dragingX , scrollView.contentOffset.y);
    
    containerController.dragingX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self enableAction];
    if ([self searchCurrentPage] == self.currentPageController)//如果没有翻页成功，当前页面重新加载动画
    {
//        NSLog(@"相同");
    }
    else
    {
        [self.currentPageController clean];        //Mr.chen, reason, 14.03.31
        self.currentPageController = [self searchCurrentPage];
        [self arrangePage];
        
        self.behaviorController.pageController = self.currentPageController.currentCoverController;
        
//        self.currentPageController.currentCoverController.behaviorController = self.behaviorController; //Mr.chen, 04.19.2014
        [self.currentPageController.currentCoverController beginView];     //Mr.chen, 04.19.2014, beginView From Here
    }
    
//    SliderCoverPageController *fp = [self firstPage];
//    SliderCoverPageController *mp = [self middlePage];
//    SliderCoverPageController *lp = [self lastPage];
//    
//    NSLog(@"\n sliderCover: \n%@,\n %@ ,\n %@",NSStringFromCGRect(fp.view.frame),NSStringFromCGRect(mp.view.frame),NSStringFromCGRect(lp.view.frame));
//    NSLog(@"\n sliderCover.pageCover: \n%@,\n %@ ,\n %@",NSStringFromCGRect(self.page1Controller.cover1Controller.pageViewController.view.frame),NSStringFromCGRect(self.page2Controller.cover1Controller.pageViewController.view.frame),NSStringFromCGRect(self.page3Controller.cover1Controller.pageViewController.view.frame));
}

#pragma mark -
#pragma mark - go to page
- (void)scrollViewBeginGoToPage:(UIScrollView *)scrollView
{
    containerController.dragingX = scrollView.contentOffset.x;
    
//    self.behaviorController.flipController.bookViewController.publicCoverBackGroundImageView.image = nil;
}

- (void)scrollViewDidEndGoToPage:(UIScrollView *)scrollView
{
    
}

#pragma mark -
#pragma mark - layout Page

-(void) arrangePage
{
    HLSliderCoverPageController *fp = [self firstPage];
    HLSliderCoverPageController *mp = [self middlePage];
    HLSliderCoverPageController *lp = [self lastPage];
    
//    NSLog(@"\n sliderCover: \n%@,\n %@ ,\n %@",NSStringFromCGRect(fp.view.frame),NSStringFromCGRect(mp.view.frame),NSStringFromCGRect(lp.view.frame));
//    NSLog(@"\n sliderCover.pageCover: \n%@,\n %@ ,\n %@",NSStringFromCGRect(self.page1Controller.cover1Controller.pageViewController.view.frame),NSStringFromCGRect(self.page2Controller.cover1Controller.pageViewController.view.frame),NSStringFromCGRect(self.page3Controller.cover1Controller.pageViewController.view.frame));
//    
    if (self.currentPageController == fp)
    {
        CGRect fpf    = fp.view.frame;
        fp.view.frame = mp.view.frame;
        mp.view.frame = lp.view.frame;
        lp.view.frame = fpf;
        
        clearScrollView.contentOffset = CGPointMake(self.currentPageController.view.frame.origin.x, 0);
    }
    else
    {
        if (self.currentPageController == mp)
        {
            
        }
        else
        {
            if (self.currentPageController == lp)
            {
                CGRect lpf = lp.view.frame;
                lp.view.frame = mp.view.frame;
                mp.view.frame = fp.view.frame;
                fp.view.frame = lpf;
                
                clearScrollView.contentOffset = CGPointMake(self.currentPageController.view.frame.origin.x, 0);
            }
        }
    }
}

- (void)loadCoverPageEntity:(HLPageEntity *)pageEntity direction:(CCoverDirection)aDirection
{
    HLSliderCoverPageController *coverPageViewCotroller = nil;
    HLPageEntity *coverPageEntity = nil;
    
    if (pageEntity != nil)
    {
        coverPageEntity = [HLPageDecoder decode:pageEntity.beCoveredPageID path:self.rootPath];
    }

    switch (aDirection)
    {
        case CCoverDirectionLeft:
        {
            coverPageViewCotroller = [self firstPage];
        }
            break;
            
        case CCoverDirectionRight:
        {
            coverPageViewCotroller = [self lastPage];
        }
            break;
    }
    [coverPageViewCotroller.currentCoverController clean];
    [coverPageViewCotroller.currentCoverController loadEntity:coverPageEntity];
    coverPageViewCotroller.currentCoverPageid = coverPageEntity.entityid;     //Mr.chen, 05.07.2014, change coverBackground
    

    
//    [coverPageViewCotroller.currentCoverController beginView];     //Mr.chen, 04.19.2014, 不能在这里调用
}

#pragma mark -
#pragma mark - Get Page
-(HLSliderCoverPageController *) searchCurrentPage
{
    float dx   = clearScrollView.contentOffset.x;
    float p1dx = self.page1Controller.view.frame.origin.x+clearScrollView.frame.size.width;
    float p2dx = self.page2Controller.view.frame.origin.x+clearScrollView.frame.size.width;
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

-(HLSliderCoverPageController *) firstPage
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

-(HLSliderCoverPageController *) middlePage
{
    float p1dx = self.page1Controller.view.frame.origin.x;
    float p2dx = self.page2Controller.view.frame.origin.x;
    if (p1dx == clearScrollView.frame.size.width)
    {
        return self.page1Controller;
    }
    else
    {
        if (p2dx == clearScrollView.frame.size.width)
        {
            return self.page2Controller;
        }
        else
        {
            return self.page3Controller;
        }
    }
}

-(HLSliderCoverPageController *) lastPage
{
    float p1dx = self.page1Controller.view.frame.origin.x;
    float p2dx = self.page2Controller.view.frame.origin.x;
    if (p1dx == clearScrollView.frame.size.width * 2)
    {
        return self.page1Controller;
    }
    else
    {
        if (p2dx == clearScrollView.frame.size.width * 2)
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
#pragma mark - Other
//- (void)loadCoverWithCurrentPageEntity:(PageEntity *)pageEntity
//{
//    self.currentPageid = pageEntity.beCoveredPageID;
//    PageEntity *coverPageEntity = [PageDecoder decode:self.currentPageid path:self.currentPageController.bookEntity.rootPath];
//    PageViewController *CurpageViewController = [self searchCurrentPage].pageViewController;
//    if (self.page1Controller.pageViewController != CurpageViewController)
//    {
//        [self.page1Controller clean];
//        [self.page1Controller loadEntity:coverPageEntity];
//    }
//    if (self.page2Controller.pageViewController != CurpageViewController)
//    {
//        [self.page2Controller clean];
//        [self.page2Controller loadEntity:coverPageEntity];
//    }
//    if (self.page3Controller.pageViewController != CurpageViewController)
//    {
//        [self.page3Controller clean];
//        [self.page3Controller loadEntity:coverPageEntity];
//    }
//    
//    self.isVerticalPageType = self.currentPageController.currentPageEntity.isVerticalPageType;
//}

-(void) enableAction
{
    self.page1Controller.view.userInteractionEnabled = YES;
    self.page2Controller.view.userInteractionEnabled = YES;
    self.page3Controller.view.userInteractionEnabled = YES;
}

-(void) disableAction
{
    self.page1Controller.view.userInteractionEnabled = NO;
    self.page2Controller.view.userInteractionEnabled = NO;
    self.page3Controller.view.userInteractionEnabled = NO;
}


#pragma mark -
#pragma mark - Memory manager
- (void)dealloc
{
    [self.page1Controller.view removeFromSuperview];
    [self.page2Controller.view removeFromSuperview];
    [self.page3Controller.view removeFromSuperview];
    [self.page1Controller release];
    [self.page2Controller release];
    [self.page3Controller release];
    [super dealloc];
}



@end

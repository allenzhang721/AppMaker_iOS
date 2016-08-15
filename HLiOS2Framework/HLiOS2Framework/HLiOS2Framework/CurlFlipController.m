//
//  CurlFlipController.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-6-3.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "CurlFlipController.h"
#import "BasicControlPanelViewController.h"
#import "PageDecoder.h"
#import "PageDecoder.h"
#import "FlowCoverNav.h"
#import "LineCoverNav.h"

@interface CurlFlipController ()
@end

@implementation CurlFlipController

#pragma mark -
#pragma mark - Life Cycle


- (id)init
{
    self = [super init];
    if (self)
    {   
        if (self.curPageController == nil)
        {
            isScrollCurl                              = YES;
            self.curlPageViewController               = [[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil] autorelease];

            UISwipeGestureRecognizer *gesture         = [[[UISwipeGestureRecognizer alloc] init] autorelease];
            gesture.delegate                          = self;
            [self.curlPageViewController.view addGestureRecognizer:gesture];

            self.curlPageViewController.dataSource    = self;
            self.curlPageViewController.delegate      = self;

            self.curPageController                    = [[[PageController alloc] init] autorelease];
            self.behaviorController                   = [[[BehaviorController alloc]init] autorelease];
            self.behaviorController.flipController    = self;
            self.behaviorController.pageController    = self.curPageController;
            self.curPageController.behaviorController = self.behaviorController;
            NSString *mainBundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"appMakerResources.bundle"];
            NSBundle *frameworkBundle = [NSBundle bundleWithPath:mainBundlePath];
            NSURL *audioUrl =  [NSURL fileURLWithPath:[frameworkBundle pathForResource:@"flip" ofType:@"mp3"]]; //            @"flip.mp3"
            audioPlayer                               = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
            [audioPlayer prepareToPlay];
        }
    }
    return self;
}

-(void) setAutoPlay:(Boolean) value
{
    self.curPageController.isAutoPlay = value;
}

-(void) openBook
{
    [super openBook];
    self.curPageController.rootPath = self.rootPath;
    [self.curPageController setup:CGRectMake(0, 0, self.viewController.view.frame.size.width, self.viewController.view.frame.size.height)];
    self.viewController.view.userInteractionEnabled = YES;
    [self.viewController.view addSubview:self.curlPageViewController.view];
    //    [self.pageController setupGesture];
    if ([self.bookEntity.navType isEqualToString:@"threed_navigation_view"])
    {
        self.navView  = [[[FlowCoverNav alloc] init] autorelease];
    }
    else
    {
        self.navView  = [[[LineCoverNav alloc] init] autorelease];
    }
    self.navView.flipView = self;
    self.navView.rootpath = self.rootPath;
    self.navView.isVertical = self.bookEntity.isVerticalMode;
    self.navView.hidden = YES;
    self.navView.userInteractionEnabled = YES;
    [self.navView load];
    [self.viewController.view addSubview:self.navView];
    self.curPageController.bookEntity = self.bookEntity;
    [self.curlPageViewController setViewControllers:[NSArray arrayWithObject:self.curPageController.pageViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

-(void) strartView
{
    if ([self.sectionPages count] >= 1)
    {
        self.curPageController.pageViewController.view.userInteractionEnabled = NO;
        PageEntity *pageEntity = [PageDecoder decode:self.bookEntity.launchPage path:self.rootPath];
        self.controlPanelViewController.view.hidden = YES;
        [self.curPageController loadEntity:pageEntity];
        [self.curPageController beginView];
        [self performSelector:@selector(onLaunched) withObject:nil afterDelay:self.bookEntity.startDelay];
    }
}

-(void) onLaunched
{
    [self.curPageController clean];
    self.controlPanelViewController.view.hidden = NO;
    if ([self.sectionPages count] >= 1)
    {
        [self loadPage:self.currentPageIndex];
        self.navView.snapshots = [self.bookEntity getSectionSnapshots:self.currentPageIndex];
        self.navView.snapTitles = [self.bookEntity getSectionSnapTitles:self.currentPageIndex];
        [self.navView refresh];
        self.navView.hidden = NO;
        //        if (self.backgroundMusic != nil)
        //        {
        //            [self.backgroundMusic play];
        //        }
        [self.curPageController beginView];
        self.curPageController.pageViewController.view.userInteractionEnabled = YES;
    }
}

-(void) close
{
    if (self.backgroundMusic != nil)
    {
        [self.backgroundMusic stop];
    }
    [self.curPageController clean];
}

#pragma mark -
#pragma mark - Page Control

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


-(void) homePage
{
    if (self.bookEntity.isVerHorMode == YES)
    {
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if ((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        {
            PageEntity *pgEntity  = [[PageDecoder decode:self.bookEntity.homepageid path:self.rootPath] retain];
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

- (void)confireGotoPage:(int)index animate:(Boolean)animate{
    
    if (animate == NO)
    {
        self.isBusy = NO;
    }
    if (self.isBusy == YES)
    {
        return;
    }
    Boolean direction;
    if (self.currentPageIndex < index)
    {
        direction = YES;
    }
    else
    {
        direction = NO;
    }
    self.currentPageIndex = index;
    self.currentPageid    = [self.sectionPages objectAtIndex:index];
    if ([self.currentPageid compare:self.homePageid]==NSOrderedSame)
    {
        direction = NO;
    }
    if (!isScrollCurl)
    {
        self.beforePageController = nil;
        self.afterPageController = nil;
        PageController *curPageController = [[[PageController alloc] init] autorelease];
        curPageController.isBeginView = NO;
        
        if (direction)
        {
            self.beforePageController = self.curPageController;
            self.afterPageController = curPageController;
        }
        else
        {
            self.afterPageController = self.curPageController;
            self.beforePageController = curPageController;
        }
        
        self.curPageController = curPageController;
        self.behaviorController.pageController = curPageController;
        curPageController.behaviorController = self.behaviorController;
        [self displayPage];
        [self.curPageController beginView];
        if (direction)
        {
            [self.curlPageViewController setViewControllers:[NSArray arrayWithObject:self.curPageController.pageViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
        else
        {
            [self.curlPageViewController setViewControllers:[NSArray arrayWithObject:self.curPageController.pageViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }
        isScrollCurl = NO;
        return;
    }
    isScrollCurl = NO;
    [self displayPage];
    [self.curPageController beginView];
}

-(void) displayPage
{
    self.curPageController.rootPath = self.rootPath;
    [self.curPageController setup:CGRectMake(0, 0, self.viewController.view.frame.size.width, self.viewController.view.frame.size.height)];
    self.curPageController.bookEntity = self.bookEntity;
    
    [self loadPage:self.currentPageIndex];
}

-(void) loadPage:(int) index
{
    if (self.navView != nil)
    {
        [self.navView popdown];
    }
    PageEntity *pageEntity = [PageDecoder decode:[self.sectionPages objectAtIndex:index] path:self.rootPath];
    [self.controlPanelViewController refreshPanel:self.currentPageIndex count:[self.sectionPages count] enableNav:pageEntity.enbableNavigation];
    self.currentPageid = pageEntity.entityid;
    self.curPageController.isBeginView = NO;
    [self.curPageController loadEntity:pageEntity];
    self.isVerticalPageType = self.curPageController.currentPageEntity.isVerticalPageType;
    self.navView.allPageIdArr = [self.bookEntity getAllPageId:self.currentSectionIndex rootPath:self.rootPath];
    if (!self.navView.allSectionPageId)
    {
        self.navView.allSectionPageId = [self.bookEntity getAllSectionPageId];
    }
}

-(BOOL) returnToLastPage:(Boolean) animate
{
    if (self.curPageController.currentPageEntity.isVerticalPageType == self.curPageController.lastPageIsVertical)
    {
        //        [self gotoPageWithPageID:self.pageController.lastPageLinkID :animate];
        return [self gotoPageWithPageID:self.curPageController.lastPageID animate:animate];//跳转修改
    }
    else
    {
        //        [self gotoPageWithPageID:self.pageController.lastPageLinkID :animate];
        return [self gotoPageWithPageID:self.curPageController.lastPageID animate:animate];
    }
}
-(CGRect) getPageRect
{
    return self.curPageController.pageViewController.view.frame;
}

#pragma mark -
#pragma mark - Page Animaiton

-(void) animationBegin
{
    if (self.controlPanelViewController != nil)
    {
        [self.controlPanelViewController disable];
    }
    [self displayPage];
    self.isBusy = YES;
}

-(void) animationEnd
{
    if (self.controlPanelViewController != nil)
    {
        [self.controlPanelViewController enable];
    }
    [self.curPageController beginView];
    self.isBusy = NO;
}

-(void) flipEnd
{
    [self animationEnd];
}



#pragma mark -
#pragma mark - Gesture Recognizer


//防止滑动控件时 触发翻页效果 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    NSLog(@"%@",touch.view);
    isButtonSwipe = NO;
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        isButtonSwipe = YES;
        return NO;
    }
    return YES;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
//    NSLog(@"begin");
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    self.afterPageController.isBeginView = NO;
    self.beforePageController.isBeginView = NO;
    if (self.curPageController == self.beforePageController)
    {
        if (completed)
        {
            [self.afterPageController clean];
        }
        else
        {
            [self.beforePageController clean];
            self.curPageController = self.afterPageController;
            self.behaviorController.pageController = self.curPageController;
            self.curPageController.behaviorController = self.behaviorController;
            if ((self.currentPageIndex + 1) < [self.sectionPages count])
            {
                self.currentPageIndex++;
                self.currentPageid = [self.sectionPages objectAtIndex:self.currentPageIndex];
                PageEntity *pageEntity = [PageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageIndex] path:self.rootPath];
                [self.controlPanelViewController refreshPanel:self.currentPageIndex count:[self.sectionPages count] enableNav:pageEntity.enbableNavigation];
            }
        }
    }
    else
    {
        if (completed)
        {
            [self.beforePageController clean];
        }
        else
        {
            [self.afterPageController clean];
            self.curPageController = self.beforePageController;
            self.behaviorController.pageController = self.curPageController;
            self.curPageController.behaviorController = self.behaviorController;
            if ((self.currentPageIndex-1) >= 0)
            {
                self.currentPageIndex--;
                self.currentPageid = [self.sectionPages objectAtIndex:self.currentPageIndex];
                PageEntity *pageEntity = [PageDecoder decode:[self.sectionPages objectAtIndex:self.currentPageIndex] path:self.rootPath];
                [self.controlPanelViewController refreshPanel:self.currentPageIndex count:[self.sectionPages count] enableNav:pageEntity.enbableNavigation];
            }
        }
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.currentPageIndex <= 0 || isButtonSwipe)
    {
        isButtonSwipe = NO;
        return nil;
    }
    NSLog(@"before");
    PageController *curPageController = [[[PageController alloc] init] autorelease];
    curPageController.isBeginView = NO;
    self.afterPageController = self.curPageController;
    self.beforePageController = curPageController;
    self.curPageController = curPageController;
    self.behaviorController.pageController = curPageController;
    curPageController.behaviorController = self.behaviorController;
    isScrollCurl = YES;
    [self gotoPage:self.currentPageIndex-1 animate:YES];
    return curPageController.pageViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.currentPageIndex >= self.sectionPages.count - 1 || isButtonSwipe)
    {
        isButtonSwipe = NO;
        return nil;
    }
    NSLog(@"after");
    PageController *curPageController = [[[PageController alloc] init] autorelease];
    curPageController.isBeginView = NO;
    self.beforePageController = self.curPageController;
    self.afterPageController = curPageController;
    self.curPageController = curPageController;
    self.behaviorController.pageController = curPageController;
    curPageController.behaviorController = self.behaviorController;
    isScrollCurl = YES;
    [self gotoPage:self.currentPageIndex+1 animate:YES];
    return curPageController.pageViewController;
}

#pragma mark -
#pragma mark - Orientation

-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    self.isOrientation = [self.curPageController checkOrientation:interfaceOrientation];//2013.04.22
    self.isVerticalPageType = self.curPageController.currentPageEntity.isVerticalPageType;
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
    if(self.curPageController.currentPageEntity.linkPageID != nil)
    {
        if (self.curPageController.currentPageEntity.isVerticalPageType != isVertical)
        {
            PageEntity *entity  = [PageDecoder decode:self.curPageController.currentPageEntity.linkPageID path:self.rootPath];
            self.viewController.view.frame = CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue]);
            self.curPageController.bookEntity = self.bookEntity;//添加后 在模板类中获取方向信息//2013.04.22
            [self gotoPageWithPageID:self.curPageController.currentPageEntity.linkPageID animate:NO];
            [self.curPageController beginView];
        }
    }
}


#pragma mark -
#pragma mark - Dealloc



- (void)dealloc
{
    [self.curlPageViewController release];
    [self.afterPageController clean];
    [self.afterPageController release];
    [self.beforePageController clean];
    [self.beforePageController release];
    [self.curPageController clean];
    [self.curPageController release];
    [audioPlayer release];
    [super dealloc];
}


//-(void) animationFlipNext
//{
//    [self.pageController clean];
//    [UIView beginAnimations:@"Flip" context:nil];
//    [UIView setAnimationDuration:1.00];
//    [UIView setAnimationCurve:UIViewAnimationOptionCurveEaseInOut];
//    if (self.bookEntity.isVerticalMode == YES)
//    {
//        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.pageController.pageViewController.view cache:NO];
//    }
//    else
//    {
//        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.pageController.pageViewController.view cache:NO];
//    }
//    [UIView setAnimationDidStopSelector:@selector(animationEnd)];
//    [UIView setAnimationWillStartSelector:@selector(animationBegin)];
//    [UIView setAnimationDelegate:self];
//    [UIView commitAnimations];
//}
//-(void) animationFlipPre
//{
//    [self.pageController clean];
//    [UIView beginAnimations:@"Flip2" context:nil];
//    [UIView setAnimationDuration:1.00];
//    [UIView setAnimationCurve:UIViewAnimationOptionCurveEaseInOut];
//    if (self.bookEntity.isVerticalMode == YES)
//    {
//        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.pageController.pageViewController.view cache:NO];
//    }
//    else
//    {
//        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.pageController.pageViewController.view cache:NO];
//    }
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(animationEnd)];
//    [UIView setAnimationWillStartSelector:@selector(animationBegin)];
//    [UIView commitAnimations];
//}



@end

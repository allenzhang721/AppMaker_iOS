//
//  CurverFlipController.m
//  MoueeIOS2Core
//
//  Created by Allen on 12-11-29.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "CurverFlipController.h"
#import "BasicControlPanelViewController.h"
#import "PageDecoder.h"
#import "FlowCoverNav.h" 
#import "LineCoverNav.h"
#import "singleCoverController.h"

#import "CoverBaseController.h"

static NSString* const changeSingleCoverBackgroundNotification = @"changeSingleCoverBackgroundNotification";
static NSString* const fullCoverBackgroundSourceKey = @"fullCoverBackgroundSourceKey";

#define KNOTIFICATION_PAGECHANGE        @"PageChangeRefreshTag"

@interface CurverFlipController ()
{
    BOOL isChangeCover;
}

@end

@implementation CurverFlipController
@synthesize pageController;

#pragma mark -
#pragma mark - Init 

- (id)init
{
    self = [super init];
    if (self)
    {
        if (self.pageController == nil)
        {
            self.pageController = [[[PageController alloc] init] autorelease];
            //            self.navView        = [[[FlowCoverNav alloc] init] autorelease];
            self.behaviorController = [[[BehaviorController alloc]init] autorelease];
            self.behaviorController.flipController = self;
            self.behaviorController.pageController = self.pageController;
            self.pageController.behaviorController = self.behaviorController;
            
            NSString *mainBundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"appMakerResources.bundle"];
            NSBundle *frameworkBundle = [NSBundle bundleWithPath:mainBundlePath];
            NSURL *audioUrl =  [NSURL fileURLWithPath:[frameworkBundle pathForResource:@"flip" ofType:@"mp3"]]; //            @"flip.mp3"
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
            [audioPlayer prepareToPlay];
        }
        
        //      >>>>>  1.2 , publicCover
        self.coverController = [[singleCoverController alloc] init];
        //      <<<<<
    }
    return self;
}

-(void) openBook
{
    [super openBook];
    self.pageController.rootPath = self.rootPath;
    
    [self.pageController setup:CGRectMake(0,
                                          0,
                                          self.viewController.view.frame.size.width,
                                          self.viewController.view.frame.size.height)]; //
    
    self.viewController.view.userInteractionEnabled = YES;
    [self.viewController.view addSubview:self.pageController.pageViewController.view];          //加载page视图
    

    
    [self.pageController setupGesture];
    
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
    self.pageController.bookEntity = self.bookEntity;
    
    //    >>>>>  12.31,加载cover视图
    self.coverController.rootPath = self.rootPath;
    self.coverController.flipController = self;
    [self.coverController setup:CGRectMake(0,                                                   //setup
                                           0,
                                           self.viewController.view.frame.size.width,
                                           self.viewController.view.frame.size.height)];
    
    [self.pageController.pageViewController.view addSubview:self.coverController.viewController.view];
    //    <<<<<
    
}

-(void) strartView
{
    if ([self.sectionPages count] >= 1)
    {
        self.pageController.pageViewController.view.userInteractionEnabled = NO;
        PageEntity *pageEntity                                             = [PageDecoder decode:self.bookEntity.launchPage path:self.rootPath];
        self.controlPanelViewController.view.hidden                        = YES;
        [self.pageController loadEntity:pageEntity];
        [self.pageController beginView];
        [self performSelector:@selector(onLaunched) withObject:nil afterDelay:self.bookEntity.startDelay];
    }
}

-(void) onLaunched
{
    [self.pageController clean];
    self.controlPanelViewController.view.hidden = NO;
    if ([self.sectionPages count] >= 1)
    {
        [self loadPage:self.currentPageIndex];
        self.navView.snapshots  = [self.bookEntity getSectionSnapshots:self.currentPageIndex];
        self.navView.snapTitles = [self.bookEntity getSectionSnapTitles:self.currentPageIndex];
        self.navView.hidden     = NO;
        [self.navView refresh];
        
        if (self.backgroundMusic != nil)
        {
            [self.backgroundMusic play];
        }
//        [self.pageController beginView];
        self.pageController.pageViewController.view.userInteractionEnabled = YES;
        
        
        [self loadCoverByPageID:self.currentPageid];        // 1.2
        [self.pageController beginView];
        [self.coverController beginView];
        
        // >>>>>  Mr.chen, 04.20.2014, Public Cover Background
        NSString *rootPath = self.rootPath;
        NSString *coverResourceID = ((singleCoverController *)self.coverController).pageController.pageViewController.pageEntity.background.dataid;
        NSString *fullCoverBackgroundSourcePath = [rootPath stringByAppendingPathComponent:coverResourceID];
        NSDictionary *dic = @{@"fullCoverBackgroundSourceKey": fullCoverBackgroundSourcePath};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSingleCoverBackgroundNotification" object:nil userInfo:dic];
        // <<<<<
        
    }
}


#pragma mark -
#pragma mark - loadPage

-(void) loadPage:(int) index
{
    if (self.navView != nil)
    {
        [self.navView popdown];
    }
    PageEntity *pageEntity = [PageDecoder decode:[self.sectionPages objectAtIndex:index] path:self.rootPath];
    [self.controlPanelViewController refreshPanel:self.currentPageIndex count:[self.sectionPages count] enableNav:pageEntity.enbableNavigation];
    self.currentPageid = pageEntity.entityid;
    [self.pageController loadEntity:pageEntity];
    self.isVerticalPageType = self.pageController.currentPageEntity.isVerticalPageType;
    self.navView.allPageIdArr = [self.bookEntity getAllPageId:self.currentSectionIndex rootPath:self.rootPath];
    if (!self.navView.allSectionPageId)
    {
        self.navView.allSectionPageId = [self.bookEntity getAllSectionPageId];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PAGECHANGE object:pageEntity.entityid];
}

//      >>>>> 1.2
- (void) loadCoverWithPage:(int) index
{
    
    PageEntity *pageEntity = [PageDecoder decode:[self.sectionPages objectAtIndex:index] path:self.rootPath];
    [self.coverController clean];
    [self.coverController loadCoverWithCurrentPageEntity:pageEntity];
//    [self.coverController beginView];
}

- (void)loadCoverByPageID:(NSString *)pageid
{
    PageEntity *curPageEntiy = [PageDecoder decode:pageid path:self.bookEntity.rootPath];
    [self.coverController clean];
    [self.coverController loadCoverWithCurrentPageEntity:curPageEntiy];
//    [self.coverController beginView];
}
//      <<<<<

-(void) displayPage
{
    [self loadPage:self.currentPageIndex];
}

- (void) displayCover
{
    //      >>>>>   //Mr.chen, reason, 2014.04.04
    if (isChangeCover) {
        
        [self loadCoverWithPage:self.currentPageIndex];
    }
    
    //      <<<<<
    
}

- (void)delayShow
{
    [self.behaviorController.pageController clean];
    [self displayPage];
    [self.behaviorController.pageController beginView];
    
    [self displayCover];    // 1.10
}

#pragma mark -
#pragma mark - Go to page

-(void) nextPage
{
//    NSLog(@"sectionPages:%d",self.sectionPages.count);
    if ((self.currentPageIndex+1) < [self.sectionPages count])
    {
        
        [self gotoPage:self.currentPageIndex+1 animate:YES];
    }
}

-(void) prePage
{
//    NSLog(@"sectionPages:%d",self.sectionPages.count);
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

- (void)confireGotoPage:(int)index animate:(Boolean)animate
{
    if (animate == NO)
    {
        self.isBusy = NO;
    }
    if (self.isBusy == YES)
    {
        return;
    }
    Boolean direction;
    
    if (self.confireGotoPage)//added by Adward 13-12-20
    {
        if (self.preSectionIndex < self.nextSectionIndex)
        {
            direction = YES;
        }
        else if(self.preSectionIndex > self.nextSectionIndex)
        {
            direction = NO;
        }
        else
        {
            if (self.currentPageIndex < index)
            {
                direction = YES;
            }
            else
            {
                direction = NO;
            }
        }
    }
    else
    {
        //        NSLog(@"notConfire");
        if (self.currentPageIndex < index)
        {
            direction = YES;
        }
        else
        {
            direction = NO;
        }
    }
    
    //Mr.chen, reason, 2014.04.04  //      >>>>>
    NSString *changeToPageid = [self.sectionPages objectAtIndex:index];
    
    PageEntity *ChangeTopageEntity    = [PageDecoder decode:changeToPageid path:self.rootPath];
    
    NSString *currentPagelinkPageID = self.pageController.pageViewController.pageEntity.beCoveredPageID;
    
    NSString *changeToPageEntityLinkpageID = ChangeTopageEntity.beCoveredPageID;
    
    
    if ([currentPagelinkPageID compare:changeToPageEntityLinkpageID] == NSOrderedSame) {
        
        isChangeCover = NO;
        
    } else {
        
        isChangeCover = YES;
    }
    
    //      <<<<<
    
    self.currentPageIndex = index;
    self.currentPageid    = changeToPageid;
    
    if ([self.currentPageid compare:self.homePageid]==NSOrderedSame)
    {
        direction = NO;
    }
    if (animate == YES)
    {
        if (direction == YES)
        {
            [self performSelector:@selector(delayNext) withObject:nil afterDelay:.1];
        }
        else
        {
            [self performSelector:@selector(delayPre) withObject:nil afterDelay:.1];
        }
    }
    else
    {
        [self performSelector:@selector(changePage) withObject:nil afterDelay:.1];//如果是点击按钮显示图片 图片显示跳转的话不延迟会crash 调用父类的changePage方法
    }
    self.confireGotoPage = NO;
}

#pragma mark -
#pragma mark - Other





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



- (void)delayNext
{
    [audioPlayer play];
    [self animationFlipNext];
}

- (void)delayPre
{
    [audioPlayer play];
    [self animationFlipPre];
}




-(void) animationFlipNext
{
    [self.pageController clean];
    [UIView beginAnimations:@"Flip" context:nil];
    [UIView setAnimationDuration:1.00];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (self.bookEntity.isVerticalMode == YES)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.pageController.pageViewController.view cache:NO];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.pageController.pageViewController.view cache:NO];
    }
    [UIView setAnimationDidStopSelector:@selector(animationEnd)];
    [UIView setAnimationWillStartSelector:@selector(animationBegin)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
-(void) animationFlipPre
{
    [UIView beginAnimations:@"Flip2" context:nil];
    [UIView setAnimationDuration:1.00];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (self.bookEntity.isVerticalMode == YES)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.pageController.pageViewController.view cache:NO];
    
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.pageController.pageViewController.view cache:NO];
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationEnd)];
    [UIView setAnimationWillStartSelector:@selector(animationBegin)];
    [UIView commitAnimations];
}
-(void) animationBegin
{
    if (self.controlPanelViewController != nil)
    {
        [self.controlPanelViewController disable];
    }
    [self.pageController clean];
    [self displayPage];
    [self displayCover];        // 1.2
    // >>>>>  Mr.chen, 04.20.2014, Public Cover Background
    NSString *rootPath = self.rootPath;
    NSString *coverResourceID = ((singleCoverController *)self.coverController).pageController.pageViewController.pageEntity.background.dataid;
    NSString *fullCoverBackgroundSourcePath = [rootPath stringByAppendingPathComponent:coverResourceID];
    NSDictionary *dic = @{@"fullCoverBackgroundSourceKey": fullCoverBackgroundSourcePath};
    [[NSNotificationCenter defaultCenter] postNotificationName:changeSingleCoverBackgroundNotification object:nil userInfo:dic];
    // <<<<<
    self.isBusy = YES;
}

-(void) animationEnd
{
//        NSLog(@"animationEnd");
    if (self.controlPanelViewController != nil)
    {
        [self.controlPanelViewController enable];
    }
    
    [self.pageController beginView];
    [self.coverController beginView];
    
    self.isBusy = NO;
}

-(void) setAutoPlay:(Boolean) value
{
    self.pageController.isAutoPlay = value;
}




-(BOOL) returnToLastPage:(Boolean) animate
{
    if (self.pageController.currentPageEntity.isVerticalPageType == self.pageController.lastPageIsVertical)
    {
//        [self gotoPageWithPageID:self.pageController.lastPageLinkID :animate];
       return [self gotoPageWithPageID:self.pageController.lastPageID animate:animate];//跳转修改
    }
    else
    {
//        [self gotoPageWithPageID:self.pageController.lastPageLinkID :animate];
       return [self gotoPageWithPageID:self.pageController.lastPageID animate:animate];
    }
}

#pragma mark -
#pragma mark - Other


-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    self.isOrientation = [self.pageController checkOrientation:interfaceOrientation];//2013.04.22   横竖屏幕，得no
    self.isVerticalPageType = self.pageController.currentPageEntity.isVerticalPageType;
    return self.isOrientation;
}

-(CGRect) getPageRect
{
//    return self.pageController.pageViewController.view.frame; //原始
    return self.bookViewController.bookController.flipBaseViewController.view.frame;    //11.27
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
    if(self.pageController.currentPageEntity.linkPageID != nil)
    {
        NSLog(@"self.pageController.currentPageEntity.linkPageID = %@",self.pageController.currentPageEntity.linkPageID);
        if (self.pageController.currentPageEntity.isVerticalPageType != isVertical)
        {
            PageEntity *entity  = [PageDecoder decode:self.pageController.currentPageEntity.linkPageID path:self.rootPath];
            self.viewController.view.frame = CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue]);
            self.pageController.bookEntity = self.bookEntity;      //添加后 在模板类中获取方向信息//2013.04.22
            [self gotoPageWithPageID:self.pageController.currentPageEntity.linkPageID animate:NO];
            [self.pageController beginView];
        }
    }
}

-(void) flipEnd
{
    [self animationEnd];
}

-(void) close
{
    if (self.backgroundMusic != nil)
    {
        [self.backgroundMusic stop];
    }
    [self.pageController clean];
    
    if (self.coverController) {        //Mr.chen, reason, 14.03.31 
        
        [self.coverController clean];
    }
}

- (void)dealloc
{
    [self.pageController clean];
    [self.pageController release];
    [audioPlayer release];
    [super dealloc];
}



@end

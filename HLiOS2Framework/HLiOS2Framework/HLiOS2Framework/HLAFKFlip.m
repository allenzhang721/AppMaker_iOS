//
//  AFKFlip.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/16/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLAFKFlip.h"
#import "HLFlowCoverNavigationView.h"
#import "HLBasicControlPanelViewController.h"
#import "HLViewCrop.h"
#import "HLPageDecoder.h"
#import "HLLineCoverNavigationView.h"
#import "HLsingleCoverController.h"

@implementation HLAFKFlip
@synthesize pageFlipper;

#pragma mark -
#pragma mark - init

- (id)init
{
    self = [super init];
    if (self)
    {
        if (self.pageController == nil)
        {
            self.pageController = [[[HLPageController alloc] init] autorelease];
            
            self.behaviorController = [[[HLBehaviorController alloc]init] autorelease];
            self.behaviorController.flipController = self;
            self.behaviorController.pageController = self.pageController;
            self.pageController.behaviorController = self.behaviorController;
            self.pageFlipper      = [[[AFKPageFlipper alloc] init] autorelease];
            self.pageFlipper.dataSource = self;
            
            NSString *mainBundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"appMakerResources.bundle"];
           NSBundle *frameworkBundle = [NSBundle bundleWithPath:mainBundlePath];
            NSURL *audioUrl =  [NSURL fileURLWithPath:[frameworkBundle pathForResource:@"flip" ofType:@"mp3"]]; //            @"flip.mp3"
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
            [audioPlayer prepareToPlay];
            
            
            //      >>>>>  1.2 , publicCover
            self.coverController = [[HLsingleCoverController alloc] init];
            //      <<<<<
            
        }
    }
    return self;
}

-(void) openBook
{
    [super openBook];
    self.pageController.rootPath = self.rootPath;
    [self.pageController setup:CGRectMake(0, 0, self.viewController.view.frame.size.width, self.viewController.view.frame.size.height)];
    self.viewController.view.userInteractionEnabled = YES;
    [self.viewController.view addSubview:self.pageController.pageViewController.view];
    
    [self.pageController setupGesture];
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
    self.pageFlipper.frame = self.viewController.view.frame;
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
        HLPageEntity *pageEntity = [HLPageDecoder decode:self.bookEntity.launchPage path:self.rootPath];
        self.controlPanelViewController.view.hidden = YES;
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
        self.navView.snapshots = [self.bookEntity getSectionSnapshots:self.currentPageIndex];
        self.navView.snapTitles = [self.bookEntity getSectionSnapTitles:self.currentPageIndex];
        
        [self.navView refresh];
        self.navView.hidden = NO;
        if (self.backgroundMusic != nil)
        {
            [self.backgroundMusic play];
        }
//        [self.pageController beginView];
        self.pageController.pageViewController.view.userInteractionEnabled = YES;
        
        [self loadCoverByPageID:self.currentPageid];        // 1.2
        [self.pageController beginView];
    }
}


#pragma mark -
#pragma mark - Go to Page

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

-(void)confireGotoPage:(int)index animate:(Boolean)animate{
    
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
        if (self.currentPageIndex < index)
        {
            direction = YES;
        }
        else
        {
            direction = NO;
        }
    }
    
    self.currentPageIndex = index;
    self.currentPageid    = [self.sectionPages objectAtIndex:index];
    if ([self.currentPageid compare:self.homePageid]==NSOrderedSame)
    {
        direction = NO;
    }
    if (animate == YES)
    {
        if (direction == YES)
        {
            [audioPlayer play];
            [self animationFlipNext];
        }
        else
        {
            [audioPlayer play];
            [self animationFlipPre];
        }
    }
    else
    {
        //        [self.pageController clean];
        [self changePage];//调用父类的changePage方法
        //        [self.pageController beginView];
        self.isBusy = NO;
    }
    self.confireGotoPage = NO;
}

-(BOOL) returnToLastPage:(Boolean) animate
{
    if (self.pageController.currentPageEntity.isVerticalPageType == self.pageController.lastPageIsVertical)
    {
        return [self gotoPageWithPageID:self.pageController.lastPageLinkID animate:animate];
    }
    else
    {
        return [self gotoPageWithPageID:self.pageController.lastPageLinkID animate:animate];
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
    HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:index] path:self.rootPath];
    //    [self.controlPanelViewController refreshPanel:self.currentPageIndex :[self.sectionPages count] :pageEntity.enbableNavigation ];
    [self.controlPanelViewController refreshPanel:self.currentPageIndex count:[self.sectionPages count] enableNav:pageEntity.enbableNavigation];
    self.currentPageid = pageEntity.entityid;
    [self.pageController loadEntity:pageEntity];
    self.isVerticalPageType = self.pageController.currentPageEntity.isVerticalPageType;
    self.navView.allPageIdArr = [self.bookEntity getAllPageId:self.currentSectionIndex rootPath:self.rootPath];
    if (!self.navView.allSectionPageId)
    {
        self.navView.allSectionPageId = [self.bookEntity getAllSectionPageId];
    }
}

//      >>>>> 1.2
- (void) loadCoverWithPage:(int) index
{
    
    HLPageEntity *pageEntity = [HLPageDecoder decode:[self.sectionPages objectAtIndex:index] path:self.rootPath];
    [self.coverController clean];
    [self.coverController loadCoverWithCurrentPageEntity:pageEntity];
    [self.coverController beginView];
}

- (void)loadCoverByPageID:(NSString *)pageid
{
    HLPageEntity *curPageEntiy = [HLPageDecoder decode:pageid path:self.bookEntity.rootPath];
    [self.coverController clean];
    [self.coverController loadCoverWithCurrentPageEntity:curPageEntiy];
    [self.coverController beginView];
}
//      <<<<<

- (void)delayShow//12.24
{
    [self.behaviorController.pageController clean];
    [self displayPage];
    [self.behaviorController.pageController beginView];
    
    [self displayCover];    // 1.10
}

-(void) displayPage
{
    [self loadPage:self.currentPageIndex];
}


//  >>>>>
- (void) displayCover
{
    [self loadCoverWithPage:self.currentPageIndex];
}
//  <<<<<


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



-(void) animationFlipNext
{
    [self.pageFlipper setCurrentPage:3];
    [self.pageController clean];
    [self animationBegin];
    [self.pageFlipper setCurrentPage:4 animated:YES];
    [self.viewController.view addSubview:self.pageFlipper];
    [self.viewController.view bringSubviewToFront:self.pageFlipper];
    self.pageFlipper.layer.zPosition = 500000;
    self.pageFlipper.hidden = NO;
}

-(void) animationFlipPre
{
    [self.pageFlipper setCurrentPage:3];
    [self.pageController clean];
    [self animationBegin];
    [self.pageFlipper setCurrentPage:2 animated:YES];
    [self.viewController.view addSubview:self.pageFlipper];
    [self.viewController.view bringSubviewToFront:self.pageFlipper];
    self.pageFlipper.layer.zPosition = 500000;
    self.pageFlipper.hidden = NO;

}

-(void) animationBegin
{
//    NSLog(@"AFK_ANIMATIONSTART");
    if (self.controlPanelViewController != nil)
    {
        [self.controlPanelViewController disable];
    }
    [self.pageController clean];
    [self displayPage];
    [self displayCover];        // 1.2
    self.isBusy = YES;
}

-(void) animationEnd
{
//    NSLog(@"AFK_ANIMATIONEND");
    [self.pageFlipper removeFromSuperview];
    self.pageFlipper.hidden = YES;
    if (self.controlPanelViewController != nil)
    {
        [self.controlPanelViewController enable];
    }
    [self.pageController beginView];
    [self.coverController beginView];       // 1.2
    self.isBusy = NO;
}



-(void) setAutoPlay:(Boolean) value
{
    self.pageController.isAutoPlay = value;
}

-(CGRect) getPageRect
{
    return self.pageController.pageViewController.view.frame;
}



-(UIView *) viewForPage:(NSInteger) page inFlipper:(AFKPageFlipper *) pageFlipper
{
    UIImage *crop = [HLViewCrop crop:self.pageController.pageViewController.view :CGRectMake(0, 0, [self.pageController.currentPageEntity.width floatValue], [self.pageController.currentPageEntity.height floatValue])];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:crop] ;
    imgView.frame = CGRectMake(0, 0, [self.pageController.currentPageEntity.width floatValue], [self.pageController.currentPageEntity.height floatValue]);
    return imgView;
}

- (NSInteger) numberOfPagesForPageFlipper:(AFKPageFlipper *) pageFlipper
{
    return 5;
}

-(void) flipEnd
{
    [self animationEnd];
}




-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    self.isOrientation = [self.pageController checkOrientation:interfaceOrientation];//2013.04.22
    self.isVerticalPageType = self.pageController.currentPageEntity.isVerticalPageType;
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
    if(self.pageController.currentPageEntity.linkPageID != nil)
    {
        if (self.pageController.currentPageEntity.isVerticalPageType != isVertical)
        {
            HLPageEntity *entity  = [HLPageDecoder decode:self.pageController.currentPageEntity.linkPageID path:self.rootPath];
            self.viewController.view.frame = CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue]);
            self.pageController.bookEntity = self.bookEntity;//添加后 在模板类中获取方向信息//2013.04.22
            [self gotoPageWithPageID:self.pageController.currentPageEntity.linkPageID animate:NO];
            self.pageFlipper.frame = CGRectMake(0, 0, [self.pageController.currentPageEntity.width floatValue], [self.pageController.currentPageEntity.height floatValue]);
            [self.pageController beginView];
        }
    }
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
//    [self.pageFlipper release];
    [self.pageController clean];
    [self.pageController release];
    [super dealloc];
}

@end








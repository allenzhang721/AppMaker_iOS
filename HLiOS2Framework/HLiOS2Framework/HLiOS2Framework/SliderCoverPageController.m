//
//  SliderCoverPageController.m
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 14-1-8.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#import "SliderCoverPageController.h"


@interface SliderCoverPageController ()

@end

@implementation SliderCoverPageController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        
        if (self.cover1Controller == nil)
        {
            self.cover1Controller = [[PageController alloc] init];
            [self.cover1Controller release];
        }
        if (self.cover2Controller == nil)
        {
            self.cover2Controller = [[PageController alloc] init];
            [self.cover2Controller release];
        }
        if (self.cover3Controller == nil)
        {
            self.cover3Controller = [[PageController alloc] init];
            [self.cover3Controller release];
        }
        
        pageContainerController = [[SliderCoverPageContainersController alloc] init];
    }
    return self;
}

- (void)setup:(CGRect)rect
{
    self.view = [[[ClearScrollView alloc] init] autorelease];
    self.view.autoresizingMask = YES;
    self.view.frame = rect;
    clearScrollView = (ClearScrollView *)self.view;
    clearScrollView.scrollEnabled = NO;
    clearScrollView.contentSize = CGSizeMake(rect.size.width, rect.size.height * 3);
    clearScrollView.contentOffset = CGPointMake(0, rect.size.height * 1);
    
    [self.cover1Controller setup:rect WithClear:YES];
    [self.cover2Controller setup:rect WithClear:YES];
    [self.cover3Controller setup:rect WithClear:YES];
    
    self.cover1Controller.pageViewController.view.frame = CGRectMake(0, rect.size.height * 0, rect.size.width, rect.size.height);
    self.cover2Controller.pageViewController.view.frame = CGRectMake(0, rect.size.height * 1, rect.size.width, rect.size.height);
    self.cover3Controller.pageViewController.view.frame = CGRectMake(0, rect.size.height * 2, rect.size.width, rect.size.height);
    
    self.cover1Controller.behaviorController = self.behaviorContoller;
    self.cover2Controller.behaviorController = self.behaviorContoller;
    self.cover3Controller.behaviorController = self.behaviorContoller;
    
    self.cover1Controller.behaviorController.pageController = self.cover1Controller;
    self.cover2Controller.behaviorController.pageController = self.cover2Controller;
    self.cover3Controller.behaviorController.pageController = self.cover3Controller;
    
    [clearScrollView addSubview:self.cover1Controller.pageViewController.view];
    [clearScrollView addSubview:self.cover2Controller.pageViewController.view];
    [clearScrollView addSubview:self.cover3Controller.pageViewController.view];
    
    
//    self.cover1Controller.pageViewController.view.backgroundColor = [UIColor redColor];
//    self.cover2Controller.pageViewController.view.backgroundColor = [UIColor yellowColor];
//    self.cover3Controller.pageViewController.view.backgroundColor = [UIColor blueColor];
//    
//    self.cover1Controller.pageViewController.view.alpha = 0.5;
//    self.cover2Controller.pageViewController.view.alpha = 0.5;
//    self.cover3Controller.pageViewController.view.alpha = 0.5;
    
    self.currentCoverController = self.cover2Controller;
}

-(void) setupRootPath:(NSString *) path
{
    self.cover1Controller.rootPath = path;
    self.cover2Controller.rootPath = path;
    self.cover3Controller.rootPath = path;
}

- (void)initEntity:(PageEntity *)pageEntity
{
    self.currentCoverPageid = pageEntity.entityid;
    PageEntity *coverPageEntity = [PageDecoder decode:self.currentCoverPageid path:self.currentCoverController.rootPath];
    [self.currentCoverController clean];
    [self.currentCoverController loadEntity:coverPageEntity];
    if (coverPageEntity.beCoveredPageID == nil || [@"" isEqualToString:coverPageEntity.beCoveredPageID])
    {
        self.currentCoverController.pageViewController.view.frame = CGRectMake(0 ,
                                                                               self.view.bounds.size.height,
                                                                               self.view.bounds.size.width,
                                                                               self.view.bounds.size.height);
    }
    
    [self.currentCoverController beginView];
}

#pragma mark -
#pragma mark - drag to page

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    pageContainerController.beganDragY = scrollView.contentOffset.y;
    pageContainerController.DragingY = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self disableAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    clearScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x,
                                                clearScrollView.contentOffset.y + scrollView.contentOffset.y - pageContainerController.DragingY);
    
    pageContainerController.DragingY = scrollView.contentOffset.y;
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self enableAction];
    
    PageController *searchCurrentPage = [self searchCurrentPage];
    if (self.currentCoverController == searchCurrentPage)
    {
        NSLog(@"相同");
    }
    else
    {
        self.currentCoverController = searchCurrentPage;
        self.behaviorContoller.pageController = self.currentCoverController;
        self.currentPageEntity = self.currentCoverController.currentPageEntity;
        [self arrangePage];
        self.currentCoverPageid = self.currentPageEntity.entityid;
        [self cleanOtherPage];       //清除不显示的Cover
    }
    
    self.currentCoverController.pageViewController.view.frame = CGRectMake(0 ,
                                                                           self.view.bounds.size.height,
                                                                           self.view.bounds.size.width,
                                                                           self.view.bounds.size.height); // 1.10 因为与空entity的page交换frame后，frame.size会置为zero，所以要强行设置一下，这个地方是在赶工╮(╯▽╰)╭
}

#pragma mark -
#pragma mark - go to Page
- (void)scrollViewBeginGoToPage:(UIScrollView *)scrollView
{
    [self disableAction];
    pageContainerController.DragingY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndGoToPage:(UIScrollView *)scrollView
{
    [self enableAction];
}

#pragma mark -
#pragma mark - layoutPage
-(void) clean
{
        [self.cover1Controller clean];
        [self.cover2Controller clean];
        [self.cover3Controller clean];
}

- (void)cleanOtherPage
{
    if (self.cover1Controller != self.currentCoverController)
    {
        [self.cover1Controller clean];
    }
    
    if (self.cover2Controller != self.currentCoverController)
    {
        [self.cover2Controller clean];
    }
    else
    {
        [self.cover3Controller clean];
    }
}

-(void) arrangePage
{
    
    PageViewController *fp = [self firstPage];
    PageViewController *mp = [self middlePage];
    PageViewController *lp = [self lastPage];
    
    if (self.currentCoverController.pageViewController == fp)
    {
        CGRect fpf    = fp.view.frame;
        fp.view.frame = mp.view.frame;
        mp.view.frame = lp.view.frame;
        lp.view.frame = fpf;
        
        clearScrollView.contentOffset = CGPointMake(0, fp.view.frame.origin.y);
    }
    else
    {
        if (self.currentCoverController.pageViewController == mp)
        {
            
        }
        else
        {
            if (self.currentCoverController.pageViewController == lp)
            {
                CGRect lpf = lp.view.frame;
                lp.view.frame = mp.view.frame;
                mp.view.frame = fp.view.frame;
                fp.view.frame = lpf;
                
                clearScrollView.contentOffset = CGPointMake(0, lp.view.frame.origin.y);
            }
        }
    }
}

- (void)loadCoverPageEntity:(PageEntity *)pageEntity direction:(relativeDirection)aDirection
{
    PageViewController *coverPageViewCotroller = nil;
    PageEntity *coverPageEntity = nil;
    
    if (pageEntity != nil)
    {
        coverPageEntity = [PageDecoder decode:pageEntity.beCoveredPageID path:self.currentCoverController.bookEntity.rootPath];
    }
    
    switch (aDirection)
    {
        case relativeDirectionUp:
        {
            coverPageViewCotroller = [self firstPage];
        }
            break;
        case relativeDirectionDown:
        {
            coverPageViewCotroller = [self lastPage];
        }
            break;
            
        default:
            break;
    }
    [coverPageViewCotroller.pageController clean];
    [coverPageViewCotroller.pageController loadEntity:coverPageEntity];
    
//    if (coverPageEntity.entityid == nil || [@"" isEqualToString:coverPageEntity.entityid])
//    {
//        self.currentCoverController.pageViewController.view.frame = CGRectMake(0 ,
//                                                                               self.view.bounds.size.height,
//                                                                               self.view.bounds.size.width,
//                                                                               self.view.bounds.size.height);
//    }
//    
    [coverPageViewCotroller.pageController beginView];
}

#pragma mark -
#pragma mark - Get Page

-(PageController *) searchCurrentPage
{
    float dy   = ((ClearScrollView *)self.view).contentOffset.y;
    float c1dy = self.cover1Controller.pageViewController.view.frame.origin.y + clearScrollView.frame.size.height;
    float c2dy = self.cover2Controller.pageViewController.view.frame.origin.y + clearScrollView.frame.size.height;
    if ((dy < c1dy) && (dy >= self.cover1Controller.pageViewController.view.frame.origin.y))
    {
        return self.cover1Controller;
    }
    else
    {
        if ((dy < c2dy) && (dy >= self.cover2Controller.pageViewController.view.frame.origin.y))
        {
            return self.cover2Controller;
        }
        else
        {
            return self.cover3Controller;
        }
    }
}

-(PageViewController *) firstPage
{
    float targety = self.view.frame.size.height * 0;
    float c1dy = self.cover1Controller.pageViewController.view.frame.origin.y;
    float c2dy = self.cover2Controller.pageViewController.view.frame.origin.y;
    
    if (c1dy == targety)
    {
        return self.cover1Controller.pageViewController;
    }
    else
    {
        if (c2dy == targety)
        {
            return self.cover2Controller.pageViewController;
        }
        else
        {
            return self.cover3Controller.pageViewController;
        }
    }
}

-(PageViewController *) middlePage
{
    float targety = self.view.frame.size.height * 1;
    float c1dy = self.cover1Controller.pageViewController.view.frame.origin.y;
    float c2dy = self.cover2Controller.pageViewController.view.frame.origin.y;
    
    if (c1dy == targety)
    {
        return self.cover1Controller.pageViewController;
    }
    else
    {
        if (c2dy == targety)
        {
            return self.cover2Controller.pageViewController;
        }
        else
        {
            return self.cover3Controller.pageViewController;
        }
    }
}

-(PageViewController *) lastPage
{
    float targety = clearScrollView.frame.size.height * 2;
    float c1dy = self.cover1Controller.pageViewController.view.frame.origin.y;
    float c2dy = self.cover2Controller.pageViewController.view.frame.origin.y;
    
    if (c1dy == targety)
    {
        return self.cover1Controller.pageViewController;
    }
    else
    {
        if (c2dy == targety)
        {
            return self.cover2Controller.pageViewController;
        }
        else
        {
            return self.cover3Controller.pageViewController;
        }
    }
}

#pragma mark -
#pragma mark - Other
-(void) enableAction
{
    self.cover1Controller.pageViewController.view.userInteractionEnabled = YES;
    self.cover2Controller.pageViewController.view.userInteractionEnabled = YES;
    self.cover3Controller.pageViewController.view.userInteractionEnabled = YES;
}

-(void) disableAction
{
    self.cover1Controller.pageViewController.view.userInteractionEnabled = NO;
    self.cover2Controller.pageViewController.view.userInteractionEnabled = NO;
    self.cover3Controller.pageViewController.view.userInteractionEnabled = NO;
}

- (void)dealloc
{
    [self.cover1Controller.pageViewController.view removeFromSuperview];
    [self.cover2Controller.pageViewController.view removeFromSuperview];
    [self.cover3Controller.pageViewController.view removeFromSuperview];
    [self.cover1Controller release];
    [self.cover2Controller release];
    [self.cover3Controller release];
    [self.currentCoverPageid release];
    [self.currentPageEntity release];
    [self.behaviorContoller release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

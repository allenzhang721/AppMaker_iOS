//
//  singleCoverController.m
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 13-12-31.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLsingleCoverController.h"
#import "HLPageController.h"

@implementation HLsingleCoverController


#pragma mark -
#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        
        self.pageController = [[[HLPageController alloc] init] autorelease];
        self.behaviorController = [[HLBehaviorController alloc] init];
        self.pageController.behaviorController = self.behaviorController;
    }
    return self;
}



#pragma mark -
#pragma mark - Other

- (void)setup:(CGRect)rect
{
    self.viewController = [[HLCoverBaseViewController alloc] init];
    self.viewController.view.frame = rect;
    self.viewController.view.backgroundColor = [UIColor clearColor];
    self.viewController.coverController = self;
    
    self.pageController.rootPath = self.rootPath;
    [self.pageController setup:rect WithClear:YES];
    [self.pageController setupGesture];
    self.pageController.bookEntity = self.flipController.bookEntity;
    
    self.behaviorController.pageController = self.pageController;
    self.behaviorController.flipController = self.flipController;
    
    [self.viewController.view addSubview:self.pageController.pageViewController.view];
}

- (void)loadCoverWithCurrentPageEntity:(HLPageEntity *)pageEntity
{
    self.currentPageid = pageEntity.beCoveredPageID;
    HLPageEntity *coverPageEntity = [HLPageDecoder decode:self.currentPageid path:self.pageController.bookEntity.rootPath];
    [self.pageController clean];
    [self.pageController loadEntity:coverPageEntity];
    self.isVerticalPageType = self.pageController.currentPageEntity.isVerticalPageType;
    [self beginView];
}

- (void)clean
{
    [self.pageController clean];
}

- (void)beginView
{
    [self.pageController beginView];
}

#pragma mark -
#pragma mark - memory manager
- (void)dealloc
{
    [self.behaviorController release];
    [self.pageController release];
    [super dealloc];
}

@end

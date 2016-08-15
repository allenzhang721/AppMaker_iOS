//
//  CoverBaseController.h
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 13-12-31.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClearScrollView.h"
#import "FlipBaseController.h"
#import "CoverBaseViewController.h"
#import "BehaviorController.h"
#import "PageEntity.h"

@class CoverBaseViewController;
@class FlipBaseController;
@class BehaviorController;

typedef enum {
    
    CCoverDirectionLeft = 0,
    CCoverDirectionRight
    
} CCoverDirection;

@interface CoverBaseController : NSObject<UIScrollViewDelegate>

@property BOOL isVerticalPageType;
@property (nonatomic , assign) BehaviorController      *behaviorController;
@property (nonatomic , assign) FlipBaseController      *flipController;
@property (nonatomic , assign) CoverBaseViewController *viewController;
@property (nonatomic , assign) NSString                *currentPageid;
@property (nonatomic , retain) NSString                *rootPath;

-(void) close;
- (void)clean;
- (void)beginView;
- (void)setup:(CGRect)rect;
- (void)initStrategy:(NSString *)flipStrategy;
- (void)loadCoverWithCurrentPageEntity:(PageEntity *)pageEntity;
- (void)loadCoverPageEntity:(PageEntity *)pageEntity direction:(CCoverDirection)aDirection;
- (void) initEntity:(PageEntity *)pageEntity;

@end

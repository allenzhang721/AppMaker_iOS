//
//  CoverBaseController.h
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 13-12-31.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLClearScrollView.h"
#import "HLFlipBaseController.h"
#import "HLCoverBaseViewController.h"
#import "HLBehaviorController.h"
#import "HLPageEntity.h"

@class HLCoverBaseViewController;
@class HLFlipBaseController;
@class HLBehaviorController;

typedef enum {
    
    CCoverDirectionLeft = 0,
    CCoverDirectionRight
    
} CCoverDirection;

@interface HLCoverBaseController : NSObject<UIScrollViewDelegate>

@property BOOL isVerticalPageType;
@property (nonatomic , assign) HLBehaviorController      *behaviorController;
@property (nonatomic , assign) HLFlipBaseController      *flipController;
@property (nonatomic , assign) HLCoverBaseViewController *viewController;
@property (nonatomic , assign) NSString                *currentPageid;
@property (nonatomic , retain) NSString                *rootPath;

-(void) close;
- (void)clean;
- (void)beginView;
- (void)setup:(CGRect)rect;
- (void)initStrategy:(NSString *)flipStrategy;
- (void)loadCoverWithCurrentPageEntity:(HLPageEntity *)pageEntity;
- (void)loadCoverPageEntity:(HLPageEntity *)pageEntity direction:(CCoverDirection)aDirection;
- (void) initEntity:(HLPageEntity *)pageEntity;

@end

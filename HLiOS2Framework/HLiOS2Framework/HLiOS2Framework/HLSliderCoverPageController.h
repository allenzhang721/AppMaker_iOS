//
//  SliderCoverPageController.h
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 14-1-8.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLPageController.h"
#import "HLClearScrollView.h"
#import "HLSliderCoverPageContainersController.h"
#import "HLPageEntity.h"
#import "HLEnumConstant.h"

@interface HLSliderCoverPageController : UIViewController

{
    HLClearScrollView *clearScrollView;
    HLSliderCoverPageContainersController *pageContainerController;
}

@property (nonatomic , retain) HLPageController       *cover1Controller;
@property (nonatomic , retain) HLPageController       *cover2Controller;
@property (nonatomic , retain) HLPageController       *cover3Controller;

@property (nonatomic , assign) HLPageController       *currentCoverController;
@property (nonatomic , assign) HLBehaviorController   *behaviorContoller;
@property (nonatomic , retain) NSString             *currentCoverPageid;
@property (nonatomic , retain) HLPageEntity           *currentPageEntity;

- (void)setup:(CGRect)rect;                     // 1/3
- (void)setupRootPath:(NSString *) path;        // 2/3
- (void)initEntity:(HLPageEntity *)pageEntity;    // 3/3
- (void)clean;
- (void)loadCoverPageEntity:(HLPageEntity *)pageEntity direction:(relativeDirection)aDirection;
- (void)beginView;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewBeginGoToPage:(UIScrollView *)scrollView;
- (void)scrollViewDidEndGoToPage:(UIScrollView *)scrollView;


@end

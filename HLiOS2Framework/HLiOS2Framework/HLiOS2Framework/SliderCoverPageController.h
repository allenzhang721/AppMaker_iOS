//
//  SliderCoverPageController.h
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 14-1-8.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageController.h"
#import "ClearScrollView.h"
#import "SliderCoverPageContainersController.h"
#import "PageEntity.h"
#import "HLEnumConstant.h"

@interface SliderCoverPageController : UIViewController

{
    ClearScrollView *clearScrollView;
    SliderCoverPageContainersController *pageContainerController;
}

@property (nonatomic , retain) PageController       *cover1Controller;
@property (nonatomic , retain) PageController       *cover2Controller;
@property (nonatomic , retain) PageController       *cover3Controller;

@property (nonatomic , assign) PageController       *currentCoverController;
@property (nonatomic , assign) BehaviorController   *behaviorContoller;
@property (nonatomic , retain) NSString             *currentCoverPageid;
@property (nonatomic , retain) PageEntity           *currentPageEntity;

- (void)setup:(CGRect)rect;                     // 1/3
- (void)setupRootPath:(NSString *) path;        // 2/3
- (void)initEntity:(PageEntity *)pageEntity;    // 3/3
- (void)clean;
- (void)loadCoverPageEntity:(PageEntity *)pageEntity direction:(relativeDirection)aDirection;
- (void)beginView;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewBeginGoToPage:(UIScrollView *)scrollView;
- (void)scrollViewDidEndGoToPage:(UIScrollView *)scrollView;


@end

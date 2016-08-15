//
//  SliderCoverContainerController.h
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 14-1-3.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SliderCoverController.h"

typedef enum
{
    TLeftToCenter,
    TCenterToRight,
    TRightToCenter,
    TCenterToLeft
}TAnimationEndPos;

@interface SliderCoverContainerController : NSObject

{
    float lastOffsetX;
    float curOffsetX;
}

@property BOOL isInitPos;
@property float scrollSpace;
@property float beginDragX;
@property float dragingX;
@property (nonatomic,assign) PageViewController *curCoverController;
@property (nonatomic , assign) PageViewController *page1Controller;
@property (nonatomic , assign) PageViewController *page2Controller;
@property (nonatomic , assign) PageViewController *page3Controller;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

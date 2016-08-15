//
//  MoueeScrollView.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-5-21.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Component.h"

@interface HLScrollView : UIScrollView {
    CGPoint p1;
    CGPoint p2;
}

@property (nonatomic , assign) Component *com;
@property BOOL isEnableMoveable;
@property BOOL isMoveScale;

@end

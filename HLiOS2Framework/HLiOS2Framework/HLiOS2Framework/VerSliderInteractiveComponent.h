//
//  VerSliderInteractiveComponent.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-12.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"
#import "VerSliderInteractiveEntity.h"

@interface VerSliderInteractiveComponent : Component <UIScrollViewDelegate>
{
    UIScrollView *curScrollView;
    float lastOffset;
}

@property (nonatomic, retain) VerSliderInteractiveEntity *entity;

@end

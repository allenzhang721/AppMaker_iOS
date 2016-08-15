//
//  VerSliderSelectComponent.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-22.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"
#import "VerSliderSelectEntity.h"

@interface VerSliderSelectComponent : Component
{
    UIScrollView *scrollView;
}

@property (nonatomic, retain) VerSliderSelectEntity *entity;

@end

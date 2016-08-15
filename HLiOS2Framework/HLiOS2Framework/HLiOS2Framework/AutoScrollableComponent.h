//
//  AutoScrollableComponent.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-9-10.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"
#import "AutoScrollableEntity.h"

@interface AutoScrollableComponent : Component
{
    UIScrollView *curScrollView;
    NSTimer *timer;
    float speed;
}

@property (nonatomic, retain) AutoScrollableEntity *entity;

@end

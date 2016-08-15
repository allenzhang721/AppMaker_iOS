//
//  TimerComponent.h
//  MoueeiOS2Framework
//
//  Created by Pi Yi on 4/23/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"

@interface TimerComponent : Component
@property (nonatomic,retain) UILabel *display;
@property (nonatomic,retain) NSTimer *timer;
@property Boolean isStatic;
@property Boolean isMS;
@property double timeInterval;
@property int maxValue;
@property int mt;
@property BOOL isDesOrder;//是否递减计时

+(void) resetGlobal;
@end

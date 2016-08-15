//
//  TimerEntity.h
//  MoueeiOS2Framework
//
//  Created by Pi Yi on 4/23/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLContainerEntity.h"

@interface TimerEntity : HLContainerEntity
@property Boolean isDesOrder;
@property Boolean isMilliCount;
@property Boolean isStatic;
@property int fontSize;
@property float maxValue;
@property (nonatomic ,retain) NSString *color;
@end

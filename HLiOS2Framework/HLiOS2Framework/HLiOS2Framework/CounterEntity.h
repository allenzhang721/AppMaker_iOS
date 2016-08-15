//
//  CounterEntity.h
//  MoueeiOS2Framework
//
//  Created by Pi Yi on 4/23/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLContainerEntity.h"

@interface CounterEntity : HLContainerEntity
@property Boolean isGlobal;
@property int fontSize;
@property (nonatomic,retain) NSString *fontColor;
@property int maxValue;
@property int minValue;
@end

//
//  CounterComponent.h
//  MoueeiOS2Framework
//
//  Created by Pi Yi on 4/23/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"

@interface CounterComponent : Component
@property (nonatomic,retain) UILabel *display;
@property Boolean isGlobal;
@property int selfValue;

-(void) addCount:(int) value;
-(void) delCount:(int) value;
-(void) reset;

+(void) resetGlobal;
@end

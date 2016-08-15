//
//  AnimationCreator.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-16.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animation.h"

@interface AnimationCreator : NSObject
+(Animation *)  createAnimation:(NSString *) classTye;
@end

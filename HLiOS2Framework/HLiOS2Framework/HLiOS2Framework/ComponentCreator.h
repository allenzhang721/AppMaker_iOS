//
//  ComponentCreator.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-16.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Component.h"
#import "HLContainerEntity.h"

@interface ComponentCreator : NSObject

+(Component *) createComponent:(HLContainerEntity *) entity;
@end

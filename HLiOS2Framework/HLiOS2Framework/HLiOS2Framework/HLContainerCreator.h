//
//  ContainerCreator.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-15.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLContainerEntity.h"

@interface HLContainerCreator : NSObject
+ (HLContainerEntity *)createEntity:(NSString *)type moduleid:(NSString *)moduleid;
@end

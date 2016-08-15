//
//  ContainerDecoder.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-15.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContainerEntity.h"
#import "TBXML.h"
#import "Container.h"

@interface ContainerDecoder : NSObject
+(ContainerEntity *) decode:(TBXMLElement *)container sx:(float)sx sy:(float)sy;
+(Container *) createContainer:(ContainerEntity *)entity pageController:(PageController *)pageController;
@end

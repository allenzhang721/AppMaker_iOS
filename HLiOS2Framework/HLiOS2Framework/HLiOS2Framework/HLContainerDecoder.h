//
//  ContainerDecoder.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-15.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLContainerEntity.h"
#import "EMTBXML.h"
#import "HLContainer.h"

@interface HLContainerDecoder : NSObject
+(HLContainerEntity *) decode:(TBXMLElement *)container sx:(float)sx sy:(float)sy;
+(HLContainer *) createContainer:(HLContainerEntity *)entity pageController:(HLPageController *)pageController;
@end

//
//  AudioEntity.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLContainerEntity.h"

@interface AudioEntity : HLContainerEntity
{
    Boolean isAutoLoop;
}

@property Boolean isAutoLoop;
@property float   delayCount;
@property Boolean isOnlineSource;       //陈星宇，11.8
@property Boolean isControlBarShow; //added by Adward 13-12-16

@end

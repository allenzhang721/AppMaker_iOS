//
//  VideoEntity.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLContainerEntity.h"

@interface VideoEntity : HLContainerEntity
{
    Boolean isAutoLoop;
    
}
@property (nonatomic, retain) NSString *coverName;
@property Boolean isAutoLoop;
@property Boolean showControlBar;
//added by Adward 13-11-07
@property Boolean isOnlineVideo;

@property float delayCount;

@end

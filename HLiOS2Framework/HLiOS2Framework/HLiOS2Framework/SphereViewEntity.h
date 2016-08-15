//
//  SphereViewEntity.h
//  Core
//
//  Created by mac on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HLContainerEntity.h"

@interface SphereViewEntity : HLContainerEntity
{
    NSMutableArray *images;
}
@property (nonatomic , retain) NSMutableArray *images;
@property Boolean isLoop;
@property Boolean isAllowZoom;
@property Boolean isVertical;
@property Boolean isAutoRotation;
@property Boolean isClockWise;
@property int speed;
@end

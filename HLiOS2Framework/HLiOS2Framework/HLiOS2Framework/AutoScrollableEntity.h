//
//  AutoScrollableEntity.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-9-10.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLContainerEntity.h"

@interface AutoScrollableEntity : HLContainerEntity
{
    NSMutableArray *images;
}

@property (nonatomic , retain) NSMutableArray *images;
@property NSInteger timerDelay;
@property BOOL isVertical;

@end

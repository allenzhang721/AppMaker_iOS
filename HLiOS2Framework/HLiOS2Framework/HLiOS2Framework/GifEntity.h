//
//  GifEntity.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLContainerEntity.h"

@interface GifEntity : HLContainerEntity
{
    double duration;
    int times;
    NSMutableArray *images;
    Boolean isLoop;
}

@property Boolean isLoop;
@property int times;
@property double duration;
@property (nonatomic ,retain) NSMutableArray *images;
@property Boolean isStroyTelling;

@end

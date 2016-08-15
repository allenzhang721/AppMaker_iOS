//
//  CarouselEntity.h
//  Core
//
//  Created by mac on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HLContainerEntity.h"

@interface CarouselEntity : HLContainerEntity
{
    NSMutableArray *images;
    NSString *type;
    float cwidth;
    float cheight;
}

@property (nonatomic , retain) NSMutableArray *images;
@property (nonatomic , retain) NSString       *type;
@property float cwidth;
@property float cheight;
@property NSInteger timerDelay;

@end

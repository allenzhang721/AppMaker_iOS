//
//  CarouselComponent.h
//  Core
//
//  Created by mac on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "iCarousel.h"

@interface CarouselComponent : Component<iCarouselDataSource, iCarouselDelegate>
{
    NSMutableArray *imgs;
    Boolean isVertical;
}
@property (nonatomic , retain) NSMutableArray *imgs;

@end

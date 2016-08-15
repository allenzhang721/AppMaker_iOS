//
//  ImageSliderEntity.h
//  Core
//
//  Created by mac on 12-3-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HLContainerEntity.h"

@interface ImageSliderEntity : HLContainerEntity
{
    NSMutableArray *images;
    Boolean isVertical;
}

@property (nonatomic , retain) NSMutableDictionary *imageDesDic;
@property (nonatomic , retain) NSMutableArray *images;
@property (nonatomic , retain) NSMutableArray *imageUrls;
@property Boolean isVertical;
@property Boolean fromUrl;
@property Boolean isShowPageControl;

@end

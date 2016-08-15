//
//  ImageSliderComponent.h
//  Core
//
//  Created by mac on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "HLPageControl.h"

@class ImageSliderEntity;

@interface ImageSliderComponent : Component<UIScrollViewDelegate, HLPageControlDelegate>
{
    NSInteger imageCount;
    CGFloat imageWidth;
    CGFloat imageHeight;
    UIScrollView *curScrollView;
    UILabel *textLabel;
}

@property Boolean isVertical;

@property (nonatomic, retain) ImageSliderEntity *ime;

@end

//
//  SliderSliceComponent.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-5.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"
#import "SliceEntity.h"

@interface SliderSliceComponent : Component <UIScrollViewDelegate>
{
    UIView *scrollBgView;
    UIScrollView *leftScrollView;
    UIScrollView *rightScrollView;
    NSMutableArray *leftArray;
    NSMutableArray *rightArray;
    float width;
    float height;
    BOOL isTouch;
    int count;
    int lastIndex;
}

@property (nonatomic, retain) SliceEntity *sliceEntity;

@end

//
//  ScrollCatalogComponent.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-29.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"
#import "RootSliderScrollView.h"
#import "ScrollCatalogEntity.h"

@interface ScrollCatalogComponent : Component <RootSliderScrollViewDelegate, UIScrollViewDelegate>
{
    BOOL beginDrag;
    int _curScrollIndex;
    float lastTop;
    RootSliderScrollView *leftScrollView;
    RootSliderScrollView *centerScrollView;
    RootSliderScrollView *rightScrollView;
}

@property (nonatomic, retain) ScrollCatalogEntity *entity;

@end

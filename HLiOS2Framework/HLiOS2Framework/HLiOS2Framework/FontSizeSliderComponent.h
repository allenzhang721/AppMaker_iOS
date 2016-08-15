//
//  FontSizeSliderComponent.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-6-21.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"
#import "FontSizeSliderEntity.h"

@interface FontSizeSliderComponent : Component
{
    UISlider *slider;
}

@property (nonatomic, retain) FontSizeSliderEntity* fontSizeEntity;

@end

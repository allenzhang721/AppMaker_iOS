//
//  AdvanceAnimation.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 4/3/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "Animation.h"

@interface AdvanceAnimation : Animation
{
    NSTimer *_timer;
    CABasicAnimation * basicRotate;
    CALayer* fisrtLayer;
    float isFirstTime;
}

@property (nonatomic,retain) NSMutableArray *models;

@property (nonatomic,retain) CALayer *startLayer;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) float x;
@property (nonatomic ,assign) float y;
@property (nonatomic ,assign) float width;
@property (nonatomic ,assign) float height;

@end

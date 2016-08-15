//
//  AdvanceAnimationModel.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 4/3/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvanceAnimationModel : NSObject


@property float pointx;
@property float pointy;
@property float duration;
@property float delay;
@property float objx;
@property float objy;
@property float objwidth;
@property float objheight;
@property float objrotation;
@property float objalpha;
@property (nonatomic,retain) NSString *easeType;


@end

//
//  BehaviorController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-15.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLBehaviorEntity.h"
#import "HLFlipBaseController.h"

@class HLFlipBaseController;
@class HLPageController;

@interface HLBehaviorController : NSObject
{}

@property (nonatomic,assign) HLFlipBaseController *flipController;
@property (nonatomic,assign) HLPageController     *pageController;

-(Boolean) runBehavior:(NSString *)containerid entity:(HLBehaviorEntity *)entity;
-(void) nextPage;
-(void) prePage;
@end

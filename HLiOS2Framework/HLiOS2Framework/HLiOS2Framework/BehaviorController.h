//
//  BehaviorController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-15.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BehaviorEntity.h"
#import "FlipBaseController.h"

@class FlipBaseController;
@class PageController;

@interface BehaviorController : NSObject
{}

@property (nonatomic,assign) FlipBaseController *flipController;
@property (nonatomic,assign) PageController     *pageController;

-(Boolean) runBehavior:(NSString *)containerid entity:(BehaviorEntity *)entity;
-(void) nextPage;
-(void) prePage;
@end

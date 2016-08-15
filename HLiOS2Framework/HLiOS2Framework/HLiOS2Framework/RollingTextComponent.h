//
//  RollingTextComponent.h
//  Core
//
//  Created by Mouee-iMac on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "EGOTextView.h"
#import "FTCoreTextView.h"

@class RollingTextEntity;

@interface RollingTextComponent : Component
{
    UILabel *label;
    EGOTextView *egoText;
    FTCoreTextView *coreTextView;
}

@property (nonatomic, retain) RollingTextEntity* rollingEntity;

//-(id)initWithEntity:(RollingTextEntity*)entity rootPath:(NSString *)rootPath pageId:(NSString *)pageid;

-(void)changeFontSize:(NSString *)size;

@end

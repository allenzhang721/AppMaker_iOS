//
//  LanternSlideEntity.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-9-12.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "LanternSlideEntity.h"

@implementation LanternSlideEntity
@synthesize swipeDir;
@synthesize isSwipe;
- (id)init
{
    self = [super init];
    if (self)
    {
        self.showImgArr = [[[NSMutableArray alloc] init] autorelease];
        self.animationTypeArr = [[[NSMutableArray alloc] init] autorelease];
        self.animationDirArr = [[[NSMutableArray alloc] init] autorelease];
        self.animationDurationArr = [[[NSMutableArray alloc] init] autorelease];
        self.animationDelayArr = [[[NSMutableArray alloc] init] autorelease];
        
        self.isAutoPlay = NO;
        self.isClickSwitch = YES;
        self.isSlideSwitch = YES;
        self.isLoop = NO;
        //        self.loopCount = 1;
        self.isEndToStart = NO;
        self.isSwipe = NO;
    }
    
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    TBXMLElement *switchType    = [EMTBXML childElementNamed:@"SwitchType"  parentElement:data];
    if (switchType != nil)
    {
        NSString *switchTypeStr = [EMTBXML textForElement:switchType];
        if ([switchTypeStr isEqualToString:@"slide"])
        {
            self.isSlideSwitch = YES;
            self.isClickSwitch = NO;
        }
        else if([switchTypeStr isEqualToString:@"click"])
        {
            self.isClickSwitch = YES;
            self.isSlideSwitch = NO;
        }
        else
        {
            self.isClickSwitch = YES;
            self.isSlideSwitch = YES;
        }
    }
    
    TBXMLElement *isLoop = [EMTBXML childElementNamed:@"IsLoop"  parentElement:data];
    if (isLoop != nil)
    {
        if ([[EMTBXML textForElement:isLoop] isEqualToString:@"true"])
        {
            self.isLoop = YES;
        }
        
        //        if (self.isLoop)
        //        {
        //            TBXMLElement *repeat = [TBXML childElementNamed:@"Repeat"  parentElement:data];
        //            if (repeat != nil)
        //            {
        //                self.loopCount = [[TBXML textForElement:repeat] intValue];
        //            }
        //        }
    }
    
    TBXMLElement *isEndToStart = [EMTBXML childElementNamed:@"IsEndToStart"  parentElement:data];
    if (isEndToStart != nil)
    {
        if ([[EMTBXML textForElement:isEndToStart] isEqualToString:@"true"])
        {
            self.isEndToStart = YES;
        }
    }
    
    TBXMLElement *images = [EMTBXML childElementNamed:@"Images"  parentElement:data];
    if (images != nil)
    {
        TBXMLElement *image = [EMTBXML childElementNamed:@"Image"  parentElement:images];
        while (image)
        {
            TBXMLElement *aniType = [EMTBXML childElementNamed:@"AniType"  parentElement:image];
            TBXMLElement *aniProperty = [EMTBXML childElementNamed:@"AniProperty"  parentElement:image];
            TBXMLElement *delay = [EMTBXML childElementNamed:@"Delay"  parentElement:image];
            TBXMLElement *duration = [EMTBXML childElementNamed:@"Duration"  parentElement:image];
            TBXMLElement *sourceID = [EMTBXML childElementNamed:@"SourceID"  parentElement:image];
            
            NSString *aniTypeStr = [EMTBXML textForElement:aniType];
            MoueeAnimationType type = AnimationTypeFade;
            if ([aniTypeStr isEqualToString:@"transitionFade"])
            {
                type = AnimationTypeFade;
            }
            else if ([aniTypeStr isEqualToString:@"transitionPush"])
            {
                type = AnimationTypePush;
            }
            else if ([aniTypeStr isEqualToString:@"transitionReveal"])
            {
                type = AnimationTypeReveal;
            }
            else if ([aniTypeStr isEqualToString:@"transitionMoveIn"])
            {
                type = AnimationTypeMoveIn;
            }
            else if ([aniTypeStr isEqualToString:@"cubeEffect"])
            {
                type = AnimationTypeCubeEffect;
            }
            else if ([aniTypeStr isEqualToString:@"suckEffect"])
            {
                type = AnimationTypeSuckEffect;
            }
            else if ([aniTypeStr isEqualToString:@"flipEffect"])
            {
                type = AnimationTypeFlipEffect;
            }
            else if ([aniTypeStr isEqualToString:@"rippleEffect"])
            {
                type = AnimationTypeRippleEffect;
            }
            else if ([aniTypeStr isEqualToString:@"pageCurl"])
            {
                type = AnimationTypePageCurl;
            }
            else if ([aniTypeStr isEqualToString:@"pageUnCurl"])
            {
                type = AnimationTypePageUnCul;
            }
            
            [self.animationTypeArr addObject:[NSNumber numberWithInt:type]];
            
            NSString * aniDirStr = [EMTBXML textForElement:aniProperty];
            HLAnimationDir dir = HLAnimationDirNon;
            if ([aniDirStr isEqualToString:@"left"])
            {
                dir = HLAnimationDirRight;
            }
            else if ([aniDirStr isEqualToString:@"right"])
            {
                dir = HLAnimationDirLeft;
            }
            else if ([aniDirStr isEqualToString:@"up"])
            {
                dir = HLAnimationDirUp;
            }
            else if ([aniDirStr isEqualToString:@"down"])
            {
                dir = HLAnimationDirDown;
            }
            else
            {
                dir = HLAnimationDirNon;
            }
            [self.animationDirArr addObject:[NSNumber numberWithInt:dir]];
            
            [self.animationDelayArr addObject:[EMTBXML textForElement:delay]];
            [self.animationDurationArr addObject:[EMTBXML textForElement:duration]];
            
            [self.showImgArr addObject:[EMTBXML textForElement:sourceID]];
            
            image = [EMTBXML nextSiblingNamed:@"Image" searchFromElement:image];
        }
        self.isAutoPlay = self.isPlayAtBegining;
        self.isLoopPlay = self.isLoop;
    }
    
    [pool release];
}

-(void)dealloc
{
    [self.animationDelayArr release];
    [self.animationDurationArr release];
    [self.animationTypeArr release];
    [self.animationDirArr release];
    [self.showImgArr release];
    [super dealloc];
}

@end

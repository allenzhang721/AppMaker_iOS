//
//  ContainerDecoder.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-15.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "ContainerDecoder.h"
#import "ContainerCreator.h"
#import "ContainerTypeCreator.h"
#import "Utility.h"
#import "BehaviorEntity.h"
#import "BehaviorDecoder.h"
#import "Animation.h"
#import "AnimationDecoder.h"
#import "ComponentCreator.h"
#import "LinkageEntity.h"
#import "AdvanceAnimation.h"
#import "AdvanceAnimationModel.h"

@implementation ContainerDecoder
+(ContainerEntity *) decode:(TBXMLElement *)container sx:(float)sx sy:(float)sy
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [AnimationDecoder setSX:sx];
    [AnimationDecoder setSY:sy];
    ContainerEntity  *entity = nil;
    if (container != nil)
	{
        TBXMLElement *component  = [TBXML childElementNamed:@"Component"  parentElement:container];
        TBXMLElement *data       = [TBXML childElementNamed:@"Data"  parentElement:component];
        NSString     *className  = [TBXML textForElement:[TBXML childElementNamed:@"ClassName" parentElement:component]];
        if([TBXML childElementNamed:@"ModuleID" parentElement:data] != nil)
        {
            entity = [ContainerCreator createEntity:[ContainerTypeCreator getContainerType:className] moduleid:[TBXML textForElement:[TBXML childElementNamed:@"ModuleID" parentElement:data]]];
        }
        else
        {
            entity = [ContainerCreator createEntity:[ContainerTypeCreator getContainerType:className] moduleid:nil];
        }
        NSString *repeatCount = nil;
        if ([TBXML childElementNamed:@"AnimationRepeat"        parentElement:container]) {
            repeatCount              = [TBXML textForElement:[TBXML childElementNamed:@"AnimationRepeat"        parentElement:container]];
            entity.repeatCount        = [repeatCount intValue];
        }
        NSString *alpha = nil;
        if ([TBXML childElementNamed:@"Alpha"        parentElement:container]) {
            alpha              = [TBXML textForElement:[TBXML childElementNamed:@"Alpha"        parentElement:container]];
            entity.alpha        = [NSNumber numberWithFloat:[alpha floatValue]];
        }
        else
        {
            entity.alpha        = [NSNumber numberWithFloat:1];
        }
        NSString *x                            = [TBXML textForElement:[TBXML childElementNamed:@"X"        parentElement:container]];
        NSString *y                            = [TBXML textForElement:[TBXML childElementNamed:@"Y"        parentElement:container]];
        NSString *cwidth                       = [TBXML textForElement:[TBXML childElementNamed:@"Width"    parentElement:container]];
        NSString *cheight                      = [TBXML textForElement:[TBXML childElementNamed:@"Height"   parentElement:container]];
        NSString *rotation                     = [TBXML textForElement:[TBXML childElementNamed:@"Rotation" parentElement:container]];
        NSString *isPlayVideoOrAudioAtBegining = [TBXML textForElement:[TBXML childElementNamed:@"IsPlayVideoOrAudioAtBegining" parentElement:container]];
        NSString *isPlayAnimationAtBegining    = [TBXML textForElement:[TBXML childElementNamed:@"IsPlayAnimationAtBegining" parentElement:container]];
        NSString *isHideAtBegining             = [TBXML textForElement:[TBXML childElementNamed:@"IsHideAtBegining" parentElement:container]];
        
        
        entity.x                = [NSNumber numberWithFloat:[x floatValue]*sx];
        entity.y                = [NSNumber numberWithFloat:[y floatValue]*sy];
        entity.width            = [NSNumber numberWithFloat:[cwidth floatValue]*sx];
        entity.height           = [NSNumber numberWithFloat:[cheight floatValue]*sy];
        entity.rotation         = [NSNumber numberWithFloat:[rotation floatValue]];
        entity.isHideAtBegining = [Utility stringToBoolean:isHideAtBegining];
        
        entity.isPlayAudioOrVideoAtBegining      = [Utility stringToBoolean:isPlayVideoOrAudioAtBegining];
        entity.isPlayCacheAudioOrVideoAtBegining = [Utility stringToBoolean:isPlayVideoOrAudioAtBegining];
        entity.isPlayAnimationAtBegining         = [isPlayAnimationAtBegining boolValue];
        entity.isPlayCacheAnimationAtBegining    = [Utility stringToBoolean:isPlayAnimationAtBegining];
        entity.name                              = [TBXML textForElement:[TBXML childElementNamed:@"Name"     parentElement:container]];
        entity.entityid                          = [TBXML textForElement:[TBXML childElementNamed:@"ID"       parentElement:container]];
        //added by Adward 13-10-20
        TBXMLElement *BeLinkages = [TBXML childElementNamed:@"BeLinkages" parentElement:container];
        if (BeLinkages != nil)
        {
            
            if([TBXML childElementNamed:@"BeLinkage" parentElement:BeLinkages])
            {
                TBXMLElement *BeLinkage = [TBXML childElementNamed:@"BeLinkage" parentElement:BeLinkages];
                
                while (BeLinkage != nil)
                {
                    LinkageEntity *lingkageEntity = [[[LinkageEntity alloc]init] autorelease];
                    lingkageEntity.linkID = [TBXML textForElement:[TBXML childElementNamed:@"LinkID" parentElement:BeLinkage]];
                    lingkageEntity.rate = [[TBXML textForElement:[TBXML childElementNamed:@"Rate" parentElement:BeLinkage]] floatValue];
                    [entity.beLinkageArray addObject:lingkageEntity];
                    
                    BeLinkage = [TBXML nextSiblingNamed:@"BeLinkage" searchFromElement:BeLinkage];
                }
                
            }
        }
        TBXMLElement *gyroHor = [TBXML childElementNamed:@"IsEnableGyroHor" parentElement:container];
        if (gyroHor)
        {
            NSString *isEnableGyroHor   = [TBXML textForElement:[TBXML childElementNamed:@"IsEnableGyroHor" parentElement:container]];
            entity.isEnableGyroHor = [Utility stringToBoolean:isEnableGyroHor];
        }
        if ([TBXML childElementNamed:@"IsPushBack" parentElement:container] != nil)
        {
            entity.isPushBack = [[TBXML textForElement:[TBXML childElementNamed:@"IsPushBack" parentElement:container]] boolValue];
        }
        if ((entity.isPlayAudioOrVideoAtBegining == YES) || (entity.isPlayAnimationAtBegining == YES))
        {
            entity.isPlayAtBegining = YES;
        }
        else
        {
            entity.isPlayAtBegining = NO;
        }
        if ([TBXML childElementNamed:@"LocalSourceID" parentElement:data] != nil)
        {
            entity.dataid  = [TBXML textForElement:[TBXML childElementNamed:@"LocalSourceID" parentElement:data]];
        }
        
        //slider
        if ([TBXML childElementNamed:@"IsUseSlide" parentElement:data] != nil)
        {
            NSString *isUserSlide = [TBXML textForElement:[TBXML childElementNamed:@"IsUseSlide" parentElement:data]];
            if ([isUserSlide compare:@"true"] == NSOrderedSame)
            {
                entity.isUseSlide = YES;
            }
            else
            {
                entity.isUseSlide = false;
            }
        }
        if ([TBXML childElementNamed:@"IsPageInnerSlide" parentElement:data] != nil)
        {
            NSString *isPageInnerSlide = [TBXML textForElement:[TBXML childElementNamed:@"IsPageInnerSlide" parentElement:data]];
            if ([isPageInnerSlide compare:@"true"] == NSOrderedSame)
            {
                entity.isPageInnerSlide = YES;
            }
            else
            {
                entity.isPageInnerSlide = false;
            }
        }
        if ([TBXML childElementNamed:@"SlideBindingAlpha" parentElement:data] != nil)
        {
            entity.sliderAlpha  = [NSNumber numberWithFloat:[[TBXML textForElement:[TBXML childElementNamed:@"SlideBindingAlpha" parentElement:data]] floatValue]];
        }
        if ([TBXML childElementNamed:@"SlideBindingX" parentElement:data] != nil)
        {
            entity.sliderX  = [NSNumber numberWithFloat:[[TBXML textForElement:[TBXML childElementNamed:@"SlideBindingX" parentElement:data]] floatValue]];
        }
        if ([TBXML childElementNamed:@"SlideBindingY" parentElement:data] != nil)
        {
            entity.sliderY  = [NSNumber numberWithFloat:[[TBXML textForElement:[TBXML childElementNamed:@"SlideBindingY" parentElement:data]] floatValue]];
        }
        if ([TBXML childElementNamed:@"SlideBindingWidth" parentElement:data] != nil)
        {
            entity.sliderWidth  = [NSNumber numberWithFloat:[[TBXML textForElement:[TBXML childElementNamed:@"SlideBindingWidth" parentElement:data]] floatValue]];
        }
        if ([TBXML childElementNamed:@"SlideBindingHeight" parentElement:data] != nil)
        {
            entity.sliderHeight  = [NSNumber numberWithFloat:[[TBXML textForElement:[TBXML childElementNamed:@"SlideBindingHeight" parentElement:data]] floatValue]];
        }
        //adward 14-1-6 页内滑动
        if ([TBXML childElementNamed:@"SliderHorRate" parentElement:data] != nil)
        {
            entity.sliderHorRate  = [NSNumber numberWithFloat:[[TBXML textForElement:[TBXML childElementNamed:@"SliderHorRate" parentElement:data]] floatValue]];
        }
        if ([TBXML childElementNamed:@"SliderVerRate" parentElement:data] != nil)
        {
            entity.sliderVerRate  = [NSNumber numberWithFloat:[[TBXML textForElement:[TBXML childElementNamed:@"SliderVerRate" parentElement:data]] floatValue]];
        }
        
        
        
        [entity decode:container];
        [entity decodeData:data];
        TBXMLElement *behaviors  = [TBXML childElementNamed:@"Behaviors"  parentElement:container];
        if (behaviors != nil)
        {
            TBXMLElement *behavior   = [TBXML childElementNamed:@"Behavior"   parentElement:behaviors];
            while(behavior != nil)
            {
                BehaviorEntity *behaviorEntity = [BehaviorDecoder decode:behavior];
                [entity.behaviors addObject:behaviorEntity];
                [behaviorEntity release];
                behavior =  [TBXML nextSiblingNamed:@"Behavior" searchFromElement:behavior];
            }
        }
        
        
        TBXMLElement *animations  = [TBXML childElementNamed:@"Animations"  parentElement:container];
        if (animations != nil)
        {
            TBXMLElement *animation   = [TBXML childElementNamed:@"Animation"   parentElement:animations];
            while (animation != nil)
            {
                Animation *containerAnimation = [AnimationDecoder decode:animation];
                if (containerAnimation)
                {
                    [entity.animations addObject:containerAnimation];
                    [containerAnimation release];
                }
                animation = [TBXML nextSiblingNamed:@"Animation" searchFromElement:animation];
                if([containerAnimation isKindOfClass:[AdvanceAnimation class]])
                {
                    AdvanceAnimation *a = (AdvanceAnimation*)containerAnimation;
                    for (int i = 0 ; i < [a.models count]; i++)
                    {
                        AdvanceAnimationModel *model = [a.models objectAtIndex:i];
                        model.pointx			= model.pointx*sx;
                        model.pointy			= model.pointy*sy;
                        model.objwidth          = model.objwidth *sx;
                        model.objheight         = model.objheight*sy;
                        model.objx              = model.objx *sx;
                        model.objy              = model.objy*sy;
                    }
                }
            }
        }
        
        
        if ([TBXML childElementNamed:@"StroyTellPt" parentElement:container])   //陈星宇，10.24，拖动轨迹
        {
            TBXMLElement *stroyTellPt = [TBXML childElementNamed:@"StroyTellPt" parentElement:container];
            if ([TBXML childElementNamed:@"Pt" parentElement:stroyTellPt])
            {
                TBXMLElement *pt          = [TBXML childElementNamed:@"Pt" parentElement:stroyTellPt];
                TBXMLElement *ptX         = [TBXML childElementNamed:@"PtX" parentElement:pt];
                TBXMLElement *ptY         = [TBXML childElementNamed:@"PtY" parentElement:pt];
                
                if (pt != nil) {
                    
                    float x = [entity.x floatValue];
                    float y = [entity.y floatValue];
                    float width = [entity.width floatValue];
                    float height = [entity.height floatValue];
                    CGPoint point = CGPointMake(x + width/2, y + height/2);
                    NSValue *pointValue = [NSValue valueWithCGPoint:point];
                    [entity.stroyTellPt addObject:pointValue];     //陳星宇，10.28，記錄初始中心點
                }
                while (pt != nil)
                {
                    
                    float x = [[TBXML textForElement:ptX] floatValue];
                    float y = [[TBXML textForElement:ptY] floatValue];
                    CGPoint point = CGPointMake(x, y);
                    NSValue *pointValue = [NSValue valueWithCGPoint:point];
                    [entity.stroyTellPt addObject:pointValue];
                    
                    pt = [TBXML nextSiblingNamed:@"Pt" searchFromElement:pt];
                }
                
            }
        }
  
        if ([TBXML childElementNamed:@"IsStroyTelling" parentElement:container])    //陈星宇，10.24，拖动轨迹
        {
            NSString *isStroyTelling = [TBXML textForElement:[TBXML childElementNamed:@"IsStroyTelling" parentElement:container]];
            if ([isStroyTelling compare:@"true"] == NSOrderedSame)
            {
                entity.isStroyTelling = YES;
            }
            else
            {
                entity.isStroyTelling = NO;
            }
        }
    }
    
    [pool release];
    return entity;
}


+(Container *) createContainer:(ContainerEntity *)entity pageController:(PageController *)pageController
{
    Container *container = [[Container alloc] init];
    container.entity     = entity;
    container.pageController = pageController;
    Component *com       = [ComponentCreator createComponent:entity];
    container.component  = com;
    container.component.container = container;
    container.component.containerEntity = entity;
    [com release];
    return container;
}
@end










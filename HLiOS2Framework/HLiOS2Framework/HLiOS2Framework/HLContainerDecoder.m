//
//  ContainerDecoder.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-15.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLContainerDecoder.h"
#import "HLContainerCreator.h"
#import "HLContainerTypeCreator.h"
#import "HLUtility.h"
#import "HLBehaviorEntity.h"
#import "HLBehaviorDecoder.h"
#import "Animation.h"
#import "AnimationDecoder.h"
#import "ComponentCreator.h"
#import "HLLinkageEntity.h"
#import "AdvanceAnimation.h"
#import "AdvanceAnimationModel.h"

@implementation HLContainerDecoder
+(HLContainerEntity *) decode:(TBXMLElement *)container sx:(float)sx sy:(float)sy
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [AnimationDecoder setSX:sx];
    [AnimationDecoder setSY:sy];
    HLContainerEntity  *entity = nil;
    if (container != nil)
	{
        TBXMLElement *component  = [EMTBXML childElementNamed:@"Component"  parentElement:container];
        TBXMLElement *data       = [EMTBXML childElementNamed:@"Data"  parentElement:component];
        NSString     *className  = [EMTBXML textForElement:[EMTBXML childElementNamed:@"ClassName" parentElement:component]];
        if([EMTBXML childElementNamed:@"ModuleID" parentElement:data] != nil)
        {
            entity = [HLContainerCreator createEntity:[HLContainerTypeCreator getContainerType:className] moduleid:[EMTBXML textForElement:[EMTBXML childElementNamed:@"ModuleID" parentElement:data]]];
        }
        else
        {
            entity = [HLContainerCreator createEntity:[HLContainerTypeCreator getContainerType:className] moduleid:nil];
        }
        NSString *repeatCount = nil;
        if ([EMTBXML childElementNamed:@"AnimationRepeat"        parentElement:container]) {
            repeatCount              = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AnimationRepeat"        parentElement:container]];
            entity.repeatCount        = [repeatCount intValue];
        }
        NSString *alpha = nil;
        if ([EMTBXML childElementNamed:@"Alpha"        parentElement:container]) {
            alpha              = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Alpha"        parentElement:container]];
            entity.alpha        = [NSNumber numberWithFloat:[alpha floatValue]];
        }
        else
        {
            entity.alpha        = [NSNumber numberWithFloat:1];
        }
        
        BOOL saveData = NO;
        if ([EMTBXML childElementNamed:@"IsSaveData" parentElement:container]) {
            saveData              = [[EMTBXML textForElement:[EMTBXML childElementNamed:@"IsSaveData" parentElement:container]] boolValue];
            entity.saveData        = saveData;
        }
        else
        {
            entity.alpha        = [NSNumber numberWithFloat:1];
        }
        
        NSString *x                            = [EMTBXML textForElement:[EMTBXML childElementNamed:@"X"        parentElement:container]];
        NSString *y                            = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Y"        parentElement:container]];
        NSString *cwidth                       = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Width"    parentElement:container]];
        NSString *cheight                      = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Height"   parentElement:container]];
        NSString *rotation                     = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Rotation" parentElement:container]];
        NSString *isPlayVideoOrAudioAtBegining = [EMTBXML textForElement:[EMTBXML childElementNamed:@"IsPlayVideoOrAudioAtBegining" parentElement:container]];
        NSString *isPlayAnimationAtBegining    = [EMTBXML textForElement:[EMTBXML childElementNamed:@"IsPlayAnimationAtBegining" parentElement:container]];
        NSString *isHideAtBegining             = [EMTBXML textForElement:[EMTBXML childElementNamed:@"IsHideAtBegining" parentElement:container]];
        
        
        entity.x                = [NSNumber numberWithFloat:[x floatValue]*sx];
        entity.y                = [NSNumber numberWithFloat:[y floatValue]*sy];
        entity.width            = [NSNumber numberWithFloat:[cwidth floatValue]*sx];
        entity.height           = [NSNumber numberWithFloat:[cheight floatValue]*sy];
        entity.rotation         = [NSNumber numberWithFloat:[rotation floatValue]];
        entity.isHideAtBegining = [HLUtility stringToBoolean:isHideAtBegining];
        
        entity.isPlayAudioOrVideoAtBegining      = [HLUtility stringToBoolean:isPlayVideoOrAudioAtBegining];
        entity.isPlayCacheAudioOrVideoAtBegining = [HLUtility stringToBoolean:isPlayVideoOrAudioAtBegining];
        entity.isPlayAnimationAtBegining         = [isPlayAnimationAtBegining boolValue];
        entity.isPlayCacheAnimationAtBegining    = [HLUtility stringToBoolean:isPlayAnimationAtBegining];
        entity.name                              = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Name"     parentElement:container]];
        entity.entityid                          = [EMTBXML textForElement:[EMTBXML childElementNamed:@"ID"       parentElement:container]];
        //added by Adward 13-10-20
        TBXMLElement *BeLinkages = [EMTBXML childElementNamed:@"BeLinkages" parentElement:container];
        if (BeLinkages != nil)
        {
            
            if([EMTBXML childElementNamed:@"BeLinkage" parentElement:BeLinkages])
            {
                TBXMLElement *BeLinkage = [EMTBXML childElementNamed:@"BeLinkage" parentElement:BeLinkages];
                
                while (BeLinkage != nil)
                {
                    HLLinkageEntity *lingkageEntity = [[[HLLinkageEntity alloc]init] autorelease];
                    lingkageEntity.linkID = [EMTBXML textForElement:[EMTBXML childElementNamed:@"LinkID" parentElement:BeLinkage]];
                    lingkageEntity.rate = [[EMTBXML textForElement:[EMTBXML childElementNamed:@"Rate" parentElement:BeLinkage]] floatValue];
                    [entity.beLinkageArray addObject:lingkageEntity];
                    
                    BeLinkage = [EMTBXML nextSiblingNamed:@"BeLinkage" searchFromElement:BeLinkage];
                }
                
            }
        }
        TBXMLElement *gyroHor = [EMTBXML childElementNamed:@"IsEnableGyroHor" parentElement:container];
        if (gyroHor)
        {
            NSString *isEnableGyroHor   = [EMTBXML textForElement:[EMTBXML childElementNamed:@"IsEnableGyroHor" parentElement:container]];
            entity.isEnableGyroHor = [HLUtility stringToBoolean:isEnableGyroHor];
        }
        if ([EMTBXML childElementNamed:@"IsPushBack" parentElement:container] != nil)
        {
            entity.isPushBack = [[EMTBXML textForElement:[EMTBXML childElementNamed:@"IsPushBack" parentElement:container]] boolValue];
        }
        if ((entity.isPlayAudioOrVideoAtBegining == YES) || (entity.isPlayAnimationAtBegining == YES))
        {
            entity.isPlayAtBegining = YES;
        }
        else
        {
            entity.isPlayAtBegining = NO;
        }
        if ([EMTBXML childElementNamed:@"LocalSourceID" parentElement:data] != nil)
        {
            entity.dataid  = [EMTBXML textForElement:[EMTBXML childElementNamed:@"LocalSourceID" parentElement:data]];
        }
        
        //slider
        if ([EMTBXML childElementNamed:@"IsUseSlide" parentElement:data] != nil)
        {
            NSString *isUserSlide = [EMTBXML textForElement:[EMTBXML childElementNamed:@"IsUseSlide" parentElement:data]];
            if ([isUserSlide compare:@"true"] == NSOrderedSame)
            {
                entity.isUseSlide = YES;
            }
            else
            {
                entity.isUseSlide = false;
            }
        }
        if ([EMTBXML childElementNamed:@"IsPageInnerSlide" parentElement:data] != nil)
        {
            NSString *isPageInnerSlide = [EMTBXML textForElement:[EMTBXML childElementNamed:@"IsPageInnerSlide" parentElement:data]];
            if ([isPageInnerSlide compare:@"true"] == NSOrderedSame)
            {
                entity.isPageInnerSlide = YES;
            }
            else
            {
                entity.isPageInnerSlide = false;
            }
        }
        if ([EMTBXML childElementNamed:@"SlideBindingAlpha" parentElement:data] != nil)
        {
            entity.sliderAlpha  = [NSNumber numberWithFloat:[[EMTBXML textForElement:[EMTBXML childElementNamed:@"SlideBindingAlpha" parentElement:data]] floatValue]];
        }
        if ([EMTBXML childElementNamed:@"SlideBindingX" parentElement:data] != nil)
        {
            entity.sliderX  = [NSNumber numberWithFloat:[[EMTBXML textForElement:[EMTBXML childElementNamed:@"SlideBindingX" parentElement:data]] floatValue]];
        }
        if ([EMTBXML childElementNamed:@"SlideBindingY" parentElement:data] != nil)
        {
            entity.sliderY  = [NSNumber numberWithFloat:[[EMTBXML textForElement:[EMTBXML childElementNamed:@"SlideBindingY" parentElement:data]] floatValue]];
        }
        if ([EMTBXML childElementNamed:@"SlideBindingWidth" parentElement:data] != nil)
        {
            entity.sliderWidth  = [NSNumber numberWithFloat:[[EMTBXML textForElement:[EMTBXML childElementNamed:@"SlideBindingWidth" parentElement:data]] floatValue]];
        }
        if ([EMTBXML childElementNamed:@"SlideBindingHeight" parentElement:data] != nil)
        {
            entity.sliderHeight  = [NSNumber numberWithFloat:[[EMTBXML textForElement:[EMTBXML childElementNamed:@"SlideBindingHeight" parentElement:data]] floatValue]];
        }
        //adward 14-1-6 页内滑动
        if ([EMTBXML childElementNamed:@"SliderHorRate" parentElement:data] != nil)
        {
            entity.sliderHorRate  = [NSNumber numberWithFloat:[[EMTBXML textForElement:[EMTBXML childElementNamed:@"SliderHorRate" parentElement:data]] floatValue]];
        }
        if ([EMTBXML childElementNamed:@"SliderVerRate" parentElement:data] != nil)
        {
            entity.sliderVerRate  = [NSNumber numberWithFloat:[[EMTBXML textForElement:[EMTBXML childElementNamed:@"SliderVerRate" parentElement:data]] floatValue]];
        }
        
        
        
        [entity decode:container];
        [entity decodeData:data];
        if (entity.saveData) {
            id object = [[NSUserDefaults standardUserDefaults] objectForKey:entity.entityid];
            
            if (object != nil) {
              [entity restoreData:object];
            }
        }
        TBXMLElement *behaviors  = [EMTBXML childElementNamed:@"Behaviors"  parentElement:container];
        if (behaviors != nil)
        {
            TBXMLElement *behavior   = [EMTBXML childElementNamed:@"Behavior"   parentElement:behaviors];
            while(behavior != nil)
            {
                HLBehaviorEntity *behaviorEntity = [HLBehaviorDecoder decode:behavior];
                [entity.behaviors addObject:behaviorEntity];
                [behaviorEntity release];
                behavior =  [EMTBXML nextSiblingNamed:@"Behavior" searchFromElement:behavior];
            }
        }
        
        
        TBXMLElement *animations  = [EMTBXML childElementNamed:@"Animations"  parentElement:container];
        if (animations != nil)
        {
            TBXMLElement *animation   = [EMTBXML childElementNamed:@"Animation"   parentElement:animations];
            while (animation != nil)
            {
                Animation *containerAnimation = [AnimationDecoder decode:animation];
                if (containerAnimation)
                {
                    [entity.animations addObject:containerAnimation];
                    [containerAnimation release];
                }
                animation = [EMTBXML nextSiblingNamed:@"Animation" searchFromElement:animation];
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
        
        
        if ([EMTBXML childElementNamed:@"StroyTellPt" parentElement:container])   //陈星宇，10.24，拖动轨迹
        {
            TBXMLElement *stroyTellPt = [EMTBXML childElementNamed:@"StroyTellPt" parentElement:container];
            if ([EMTBXML childElementNamed:@"Pt" parentElement:stroyTellPt])
            {
                TBXMLElement *pt          = [EMTBXML childElementNamed:@"Pt" parentElement:stroyTellPt];
                TBXMLElement *ptX         = [EMTBXML childElementNamed:@"PtX" parentElement:pt];
                TBXMLElement *ptY         = [EMTBXML childElementNamed:@"PtY" parentElement:pt];
                
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
                    
                    float x = [[EMTBXML textForElement:ptX] floatValue];
                    float y = [[EMTBXML textForElement:ptY] floatValue];
                    CGPoint point = CGPointMake(x, y);
                    NSValue *pointValue = [NSValue valueWithCGPoint:point];
                    [entity.stroyTellPt addObject:pointValue];
                    
                    pt = [EMTBXML nextSiblingNamed:@"Pt" searchFromElement:pt];
                }
                
            }
        }
  
        if ([EMTBXML childElementNamed:@"IsStroyTelling" parentElement:container])    //陈星宇，10.24，拖动轨迹
        {
            NSString *isStroyTelling = [EMTBXML textForElement:[EMTBXML childElementNamed:@"IsStroyTelling" parentElement:container]];
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


+(HLContainer *) createContainer:(HLContainerEntity *)entity pageController:(HLPageController *)pageController
{
    HLContainer *container = [[HLContainer alloc] init];
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










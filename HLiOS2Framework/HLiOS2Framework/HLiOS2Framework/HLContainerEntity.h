//
//  ContainerEntity.h
//  MoueeiPad
//
//  Created by FloatBits on 7/18/11.
//  Copyright 2011 FloatBits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLBaseEntity.h"
#import "EMTBXML.h"

@interface HLContainerEntity : HLBaseEntity {

	NSString *name;
	NSString *fileName;
	NSString *dataid;
	NSNumber *x;
	NSNumber *y;
	NSNumber *width;
	NSNumber *height;
	NSNumber *rotation;
    Boolean  isHideAtBegining;
    Boolean  isPlayAtBegining;
    Boolean  isPlayAnimationAtBegining;
    Boolean  isPlayAudioOrVideoAtBegining;
    Boolean  isLoopPlay;
	NSMutableArray* behaviors;
	NSMutableArray* animations;
}

@property int repeatCount;
@property (nonatomic , assign) BOOL saveData; // Feature - - Emiaostein, 22 Sep 2016
@property (nonatomic , assign) NSString *rootPath;
@property (nonatomic , retain) NSString *name;
@property (nonatomic , retain) NSString *fileName;
@property (nonatomic , retain) NSString *dataid;
@property (nonatomic , retain) NSNumber *x;
@property (nonatomic , retain) NSNumber *y;
@property (nonatomic , retain) NSNumber *width;
@property (nonatomic , retain) NSNumber *height;
@property (nonatomic , retain) NSNumber *alpha;
@property (nonatomic , retain) NSNumber *sliderAlpha;
@property (nonatomic , retain) NSNumber *sliderX;
@property (nonatomic , retain) NSNumber *sliderY;
@property (nonatomic , retain) NSNumber *sliderWidth;
@property (nonatomic , retain) NSNumber *sliderHeight;
//adward 14-01-06
@property (nonatomic , retain) NSNumber *sliderHorRate;
@property (nonatomic , retain) NSNumber *sliderVerRate;

@property (nonatomic , retain) NSNumber *rotation;
@property (nonatomic , retain) NSMutableArray *behaviors;
@property (nonatomic , retain) NSMutableArray *animations;
@property (nonatomic , retain) NSMutableArray *stroyTellPt; //陈星宇

@property (nonatomic , retain) NSMutableArray *beLinkageArray;

@property Boolean isHideAtBegining;
@property Boolean isPlayAtBegining;
@property Boolean isPlayAnimationAtBegining;
@property Boolean isPlayAudioOrVideoAtBegining;
@property Boolean isPlayCacheAnimationAtBegining;
@property Boolean isPlayCacheAudioOrVideoAtBegining;
@property Boolean isLoopPlay;
@property Boolean isPushBack;
@property Boolean isEnableGyroHor;
@property Boolean isUseSlide;
@property Boolean isPageInnerSlide;

@property Boolean isStroyTelling;   //陈星宇，10.24,按轨迹拖动

-(void) decode:(TBXMLElement *)container;

-(void) decodeData:(TBXMLElement *)data;

-(void) restoreData:(id)object;

@end

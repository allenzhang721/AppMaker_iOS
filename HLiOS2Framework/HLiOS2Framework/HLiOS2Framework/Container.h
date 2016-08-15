//
//  Container.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Component.h"
#import "ContainerEntity.h"
#import "AudioEntity.h"
#import "VideoEntity.h"
#import "GifEntity.h"
#import "BehaviorEntity.h"
#import "BehaviorController.h"
#import "Animation.h"
#import "WebEntity.h"
#import "CarouselEntity.h"
#import "GridViewEntity.h"
#import "ImageSliderEntity.h"
#import "DrawerEntity.h"
#import "SlideCellEntity.h"
#import "CameraEntity.h"
#import "ImageComponent.h"
#import "PageController.h"
//@class BehaviorController;
//@class PageController;

@class PageController;

@interface Container : NSObject
{
    Component *component;
    ContainerEntity *entity;
    NSMutableArray  *inSpotContainers;
    Boolean   autoplayFlag;
    Boolean   isMediaPlayCounterAdded;
    Boolean   isAnimationCounterAdded;
    Boolean   isCleaned;
    int isPlayingAnimationCount;
    float lastImageRate;
}

@property (nonatomic , retain) NSMutableArray  *caseIdArray;
@property (nonatomic , retain) Component       *component;
@property (nonatomic , retain) ContainerEntity *entity;
@property (nonatomic , retain) NSMutableArray  *inSpotContainers;
@property (nonatomic , assign) BehaviorController  *behaviorController;
@property (nonatomic , assign) PageController  *pageController;

@property CGRect  componetRect;
@property CGPoint comStartPoint;        //陈星宇，11.11
@property Boolean autoplayFlag;
@property Boolean isMediaPlayCounterAdded;
@property Boolean isAnimationCounterAdded;
@property Boolean isCleaned;
@property Boolean isGroupPlay;
@property Boolean isSinglePlay;
@property Boolean isSpotTrigger;//区别当前container是进出热区还是回置    
@property Boolean isPlayAnimationAtBegining;
@property int animationPlayIndex;
@property int totalAnimationPlayIndex;
-(void) setX:(float) x;
-(void) setY:(float) y;
-(void) setWidth: (float)  width;
-(void) setHeight:(float) height;
-(void) setRotation:(float) rotation;
-(void) setAnchorPoint;
-(void) resetAnchorPoint:(float) rotation;
//-(void) reset;
-(void) addVideoPlayCounter;
-(void) delVideoPlayCounter;
-(void) addAnimationPlayCounter;
-(void) delAnimationPlayCounter;

-(void) beginView;
-(void) stopView;
-(void) playAll;
-(void) play;
-(void) stop;
-(void) pause;
-(void) playAnimation:(BOOL)isReset;
- (void)playSingleAnimation:(int)index;
-(void) pauseAnimation;
-(void) stopAnimation;
-(void) show;
-(void) hide;
-(void)change:(int)index;

-(void) runCaseComponent:(NSString *) eventName;


-(void) onAnimationStart;
-(void) onAnimationEnd;
-(void) onPlay;
-(void) onPlayEnd;
-(void) onShow;
-(void) onHidde;
-(void) bounceBack;

-(void) runLinkageContainerXY:(float)lx :(float)ly;
-(BOOL) runBehavior:(NSString *) eventName index:(int)index;
-(BOOL) runBehavior:(NSString *) eventName;
-(void) setSpotInContainer;
-(Boolean) runBehaviorWithEntity:(BehaviorEntity *)behavior;
-(void)runLinkageContainerWidth:(float)wchange Height :(float)hchange;
-(void)runLinkageContainerScale:(float)scale rate:(float)lastRate;
-(void)runLinkageContainerScrollView;
-(void)getComStartPoint;        //陈星宇，11.11

@end

//
//  Animation.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "HLContainer.h"
#import "EMTBXML.h"
#import "HLNSBKeyframeAnimationFunctions.h"

@interface Animation : NSObject
{
    UIView   *view;
	float    duration;
	float	 times;
    float    delay;
	Boolean  isLoop;
	Boolean  isRevser;
    Boolean  isReversPlay;
    Boolean  isPlaying;
}


@property (nonatomic,assign) HLContainer *container;
@property (nonatomic,assign) UIView   *view;
@property (nonatomic,retain) NSString *easeType;
@property CGRect containerRect;
//added by Adward 13-11-28
@property CGRect containerOriginRect;
@property float containerRotation;
@property float animationRotation;
@property CGRect animationRect;
@property Boolean  isFirstPlay;
@property Boolean  isHidden;
@property NSBKeyframeAnimationFunction easeFunction;
@property float   duration;
@property float   times;
@property float   delay;
@property Boolean isPlaying;
@property Boolean isLoop;
@property Boolean isRevser;
@property Boolean isReversPlay;
@property Boolean isKeep;
@property Boolean isKeepEndStatus;
@property Boolean isPaused;
@property  CFTimeInterval startTime;

-(void) play;
-(void) playHandler;
-(void) stop;
-(void) pause;


-(void) decode:(TBXMLElement *) data;

@end

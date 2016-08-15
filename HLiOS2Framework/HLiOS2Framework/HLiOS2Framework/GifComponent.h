//
//  GifComponent.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Component.h"

@interface GifComponent : Component
{
    float time;
    CGFloat interval;
    NSInteger currentIndex;
    Boolean timerstoped;
    BOOL isFirst;
    BOOL isPlaying;
    BOOL isPaused;//adward 1.21
    float delayTime;
}

@property float time;
@property Boolean isLoop;
@property (nonatomic, retain) NSString *rootpath;
@property (nonatomic, retain) NSMutableArray *imgs;
@property (nonatomic, retain) NSTimer *timer;


-(void) playEnd;
-(void)timerUpdate:(id)sender;
@end

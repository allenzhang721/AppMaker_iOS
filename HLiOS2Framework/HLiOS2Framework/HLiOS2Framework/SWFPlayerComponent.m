////
////  SWFPlayerComponent.m
////  MoueeIOS2Core
////
////  Created by Pi Yi on 3/7/13.
////  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
////
//
//#import "SWFPlayerComponent.h"
//#import <HLSwf/SwiffMovie.h>
//#import <HLSwf/SwiffPlayhead.h>
//#import <HLSwf/SwiffFrame.h>
//#import "Container.h"
//#import "SWFView.h"
////#import "SWFPlayerEntity.h"
//
//@implementation SWFPlayerComponent
//
//
//@synthesize isLoop;
//
//- (id)initWithEntity:(ContainerEntity *) entity
//{
//    self = [super init];
//	if (self != nil)
//	{
//        NSString *filePath = [entity.rootPath stringByAppendingPathComponent:entity.dataid];
//        NSData *fileData   = [[NSData alloc] initWithContentsOfFile:filePath];
//        CGRect movieFrame  = CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue]);
//        SwiffMovie *movie  = [[SwiffMovie alloc] initWithData:fileData];
//        self.totalFrame    = [[movie frames] count];
//        SWFView  *movieView =[[SWFView alloc] initWithFrame:movieFrame movie:movie];
//        [movieView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
//        movieView.isStoryTelling = ((SWFPlayerEntity*)entity).isStroyTelling;
//        self.isLoop              = ((SWFPlayerEntity*)entity).isLoop;
//        movieView.component = self;
//        movieView.drawsBackground = YES;
//        [movieView setDelegate:self];
//        [movieView setBackgroundColor:[UIColor clearColor]];
//        self.uicomponent = movieView;
//        if (entity.isPlayAudioOrVideoAtBegining == YES)
//        {
//            [self play];
//        }
//        if (self.totalFrame > 0)
//        {
//            [[(SWFView*)self.uicomponent playhead] gotoFrameWithIndex:1 play:NO];
//        }
//        [movieView release];
//        self.currentIndex = 0;
//        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
//    }
//    return self;
//}
//
//-(void) play
//{
//    if ([[(SwiffView*)self.uicomponent playhead] isPlaying] == NO)
//    {
//        [[(SwiffView*)self.uicomponent playhead] play];
//        [super play];
//        [self.container onPlay];
//    }
//}
//
//-(void) stop
//{
//    if (self.totalFrame > 0)
//    {
//        [[(SwiffView*)self.uicomponent playhead] gotoFrameWithIndex:1 play:NO];
//    }
//    [super stop];
//}
//
//-(void) pause
//{
//    [[(SwiffView*)self.uicomponent playhead] gotoFrameWithIndex:self.currentIndex play:NO];
//}
//
//
//- (void) swiffView:(SwiffView *)swiffView didUpdateCurrentFrame:(SwiffFrame *)frame
//{
//    self.currentIndex = [[[((SwiffView*)self.uicomponent) playhead] frame] indexInMovie];
//    if (self.currentIndex == (self.totalFrame-1))
//    {
//        if (self.isLoop == YES)
//        {
//             [[(SwiffView*)self.uicomponent playhead] gotoFrameWithIndex:1 play:YES];
//        }
//        else
//        {
//            [[(SwiffView*)self.uicomponent playhead] stop];
//            [self.container onPlayEnd];
//        }
//       
//    }
//    if (self.currentIndex == 0)
//    {
//        if (self.totalFrame > 0)
//        {
//            [[(SwiffView*)self.uicomponent playhead] gotoFrameWithIndex:1 play:YES];
//        }
//    }
//}
//@end

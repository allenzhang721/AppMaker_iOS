//
//  PageController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLPageEntity.h"
#import "HLBookEntity.h"
#import "HLPageViewController.h"
#import "HLPageDecoder.h"
#import "HLBehaviorEntity.h"
#import "HLBehaviorController.h"

@class HLPageViewController; //  1.2

@interface HLPageController : NSObject
{
    NSMutableArray* groups;
    NSMutableArray* groupDelay;
    Boolean isAutoPlay;
    Boolean isGroupAutoPlay;
    Boolean isAutoPlayEnd;
    Boolean isViewPageNavigate;
    Boolean enableBehavior;
    BOOL    isPDFCom;
}

@property (nonatomic,retain) HLPageEntity *currentPageEntity;
@property (nonatomic,retain) NSMutableArray *objects;
@property (nonatomic,assign) NSString   *rootPath;
@property (nonatomic,assign) HLBookEntity *bookEntity;
@property (nonatomic,assign) HLPageViewController *pageViewController;
@property (nonatomic,assign) HLBehaviorController *behaviorController;
@property (nonatomic,copy)   NSString *lastPageID;
@property (nonatomic,copy)   NSString *lastPageLinkID;
@property (nonatomic,retain) UIImageView *cacheImage;
@property int playCounter;
@property int groupPlayIndex;
@property int groupCounter;
@property Boolean lastPageIsVertical;
@property Boolean isAutoPlay;
@property Boolean isGroupAutoPlay;
@property Boolean isBeginView;
@property UIDeviceOrientation orientation;

-(void) clean;
-(void) beginView;
-(void) stopView; // Stop - - Emiaostein, 21 Mar 2017
-(void) resetView;

-(void) setup:(CGRect) rect;
    //     >>>>>>
-(void) setup:(CGRect) rect WithClear:(BOOL)clear;  // 1.2 穿透视图
    //     >>>>>>
-(void) setupGesture;
-(void) loadEntity:(HLPageEntity *) entity;
-(void) addCounter:(HLContainer *) container;
-(void) delCounter:(HLContainer *) container;
-(void) playGroup:(NSNumber *) index;
-(void) stopGroup:(int) index;
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) onTap;
-(void) onSwipRight;
-(void) onSwipLeft;
-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(HLContainer *) getContainerByID:(NSString *) containterid;

@end

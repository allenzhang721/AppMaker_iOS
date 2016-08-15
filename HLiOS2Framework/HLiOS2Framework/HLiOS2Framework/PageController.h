//
//  PageController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageEntity.h"
#import "HLBookEntity.h"
#import "PageViewController.h"
#import "PageDecoder.h"
#import "BehaviorEntity.h"
#import "BehaviorController.h"

@class PageViewController; //  1.2

@interface PageController : NSObject
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

@property (nonatomic,retain) PageEntity *currentPageEntity;
@property (nonatomic,retain) NSMutableArray *objects;
@property (nonatomic,assign) NSString   *rootPath;
@property (nonatomic,assign) HLBookEntity *bookEntity;
@property (nonatomic,assign) PageViewController *pageViewController;
@property (nonatomic,assign) BehaviorController *behaviorController;
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
-(void) setup:(CGRect) rect;
    //     >>>>>>
-(void) setup:(CGRect) rect WithClear:(BOOL)clear;  // 1.2 穿透视图
    //     >>>>>>
-(void) setupGesture;
-(void) loadEntity:(PageEntity *) entity;
-(void) addCounter:(Container *) container;
-(void) delCounter:(Container *) container;
-(void) playGroup:(NSNumber *) index;
-(void) stopGroup:(int) index;
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) onTap;
-(void) onSwipRight;
-(void) onSwipLeft;
-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(Container *) getContainerByID:(NSString *) containterid;

@end

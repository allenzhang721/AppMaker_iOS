//
//  PageEntity.h
//  MoueeiPad
//
//  Created by FloatBits on 7/18/11.
//  Copyright 2011 FloatBits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLBaseEntity.h"
#import "HLContainerEntity.h"

//added by Adward 13-11-27
typedef enum HLPageChangeAnimationType
{
    pageChangeAnimationTypeFade,
    pageChangeAnimationTypePush,
    pageChangeAnimationTypeReveal,
    pageChangeAnimationTypeMoveIn,
    pageChangeAnimationTypeCubeEffect,
    pageChangeAnimationTypeSuckEffect,
    pageChangeAnimationTypeFlipEffect,
    pageChangeAnimationTypeRippleEffect,
    pageChangeAnimationTypePageCurl,
    pageChangeAnimationTypePageUnCul,
    pageChangeAnimationTypeNon
}HLPageChangeAnimationType;

typedef enum HLPageChageAnimationDir
{
    pageChangeHLAnimationDirLeft,
    pageChangeHLAnimationDirRight,
    pageChangeHLAnimationDirUp,
    pageChangeHLAnimationDirDown,
    pageChangeHLAnimationDirNon
}HLPageChangeAnimationDir;

typedef NS_ENUM(NSInteger, pageEntityState)
{
    pageEntityStatePublic = 100,
    pageEntityStateNormal =101
};


@interface HLPageEntity : HLBaseEntity {

	NSString* title;
	NSString* description;
    NSString* linkPageID;
    NSString* cacheImageID;
	NSNumber* width;
	NSNumber* height;
	NSMutableArray  *containers;
    NSMutableArray  *group;
    NSMutableArray  *groupDelay;
    NSMutableArray  *navPages;
    HLContainerEntity *background;
    Boolean enbableNavigation;
    Boolean isVerticalPageType;
    Boolean isGroupPlay;
    Boolean isCached;
    
    Boolean isNeedPay;  //陈星宇
}

@property (nonatomic,retain) NSMutableArray  *groups;
@property (nonatomic,retain) NSMutableArray  *groupDelay;
@property (nonatomic,retain) NSMutableArray  *navPages;
@property (nonatomic,retain) NSString        *title;
@property (nonatomic,retain) NSString        *description;
@property (nonatomic,retain) NSString        *linkPageID;
@property (nonatomic,retain) NSString        *cacheImageID;
@property (nonatomic,retain) NSNumber        *width;
@property (nonatomic,retain) NSNumber        *height;
@property (nonatomic,retain) NSMutableArray  *containers;
@property (nonatomic,retain) HLContainerEntity *background;
@property Boolean enbableNavigation;
@property Boolean enableGesture;
@property Boolean isVerticalPageType;
@property Boolean isGroupPlay;
@property Boolean isCached;
@property Boolean isLoaded;
@property Boolean isUseSlide;
@property int contentWidth;
@property int contentHeight;

@property Boolean isNeedPay;    //陈星宇

//added by Adward 13-11-27
@property (nonatomic, retain) NSString *animationType;
@property (nonatomic, retain) NSString *animationDir;
@property (nonatomic, retain) NSString *animationDuration;

//        >>>>>    12.27，覆盖公共页
@property (nonatomic, retain) NSString        *stateString;//1、PAGE_STATIC_STATE 为公共页面； 2、PAGE_NORMAL_STATE 为普通页面。
@property (nonatomic, assign) pageEntityState state;
@property (nonatomic, retain) NSString        *beCoveredPageID;//记录覆盖此页的公共页，只有当页面为普通页面时才有值，默认为“”
@property (nonatomic, retain) NSMutableArray  *CoverPageIds;//记录此页公共页覆盖的普通页， 只有当页面为公共页的时候才有值，默认为“”
@property (nonatomic, assign) HLPageEntity      *coverPageEntity;
//        <<<<<
@end

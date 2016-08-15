//
//  BookEntity.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLBaseEntity.h"
#import "HLButtonEntity.h"
#import "HLEnumConstant.h"

@class HLPageEntity;

@interface HLBookEntity : HLBaseEntity
{
    NSString *name;
    NSString *iconPath;
    NSString *account;
    NSString *rootPath;
    NSString *launchPage;
    NSString *backgroundMusic;
    NSString *filpType;
    NSString *homepageid;
    NSString *bookType;
    HLButtonEntity *homeBtn;
    HLButtonEntity *snapBtn;
    HLButtonEntity *rightBtn;
    HLButtonEntity *leftBtn;
    NSMutableArray *pages;
    NSMutableArray *snapshots;
    NSMutableArray *sections;
    Boolean   isVerticalMode;
    Boolean   isVerHorMode;
    
//    UIScrollView
}

@property (nonatomic , retain) NSString *bookid;   //陈星宇
@property (nonatomic , retain) NSString *bookType;
@property (nonatomic , retain) NSString *name;
@property (nonatomic , retain) NSString *adPosition;
@property (nonatomic , retain) NSString *iconPath;
@property (nonatomic , retain) NSString *account;
@property (nonatomic , retain) NSString *rootPath;
@property (nonatomic , retain) NSString *launchPage;
@property (nonatomic , retain) NSString *backgroundMusic;
@property (nonatomic , retain) NSString *filpType;
@property (nonatomic , retain) NSString *homepageid;
@property (nonatomic , retain) NSString *navType;

@property (nonatomic , retain) NSString *deviceType;    //陈星宇，11.13，screen
@property (nonatomic , retain) NSString *productID;     //陈星宇
@property (nonatomic , retain) NSString *referenceName; //陈星宇
@property Boolean isPaid;                               //陈星宇ispaid;
@property Boolean isFree;
@property (nonatomic , retain) NSMutableArray   *pages;
@property (nonatomic , retain) NSMutableArray   *snapshots;
@property (nonatomic , retain) NSMutableArray   *sections;
@property (nonatomic , retain) HLButtonEntity     *bgMusicBtn;
@property (nonatomic , retain) HLButtonEntity     *searchBtn;
@property (nonatomic , retain) HLButtonEntity     *vbgMusicBtn;
@property (nonatomic , retain) HLButtonEntity     *homeBtn;
@property (nonatomic , retain) HLButtonEntity     *snapBtn;
@property (nonatomic , retain) HLButtonEntity     *rightBtn;
@property (nonatomic , retain) HLButtonEntity     *leftBtn;
@property (nonatomic , retain) HLButtonEntity     *vhomeBtn;
@property (nonatomic , retain) HLButtonEntity     *vsnapBtn;
@property (nonatomic , retain) HLButtonEntity     *vrightBtn;
@property (nonatomic , retain) HLButtonEntity     *vleftBtn;
@property (nonatomic , retain) HLButtonEntity     *exitBtn;   //Mr.chen , 1.25
@property (nonatomic , retain) HLButtonEntity     *vexitBtn;  //Mr.chen , 1.25

@property (nonatomic , assign) BOOL hasBookMarkTag; //Mr.chen, 09.10.2014, bookMark
@property (nonatomic , assign) BOOL showBookMark; //Mr.chen, 09.10.2014, bookMark
@property (nonatomic , assign) BOOL showBookMarkLabel; //Mr.chen, 09.10.2014, bookMark
@property (nonatomic , assign) HLBookEntityBookMarkPostion bookMarkPostion; //Mr.chen, 09.10.2014, bookMark
@property (nonatomic , copy) NSString *bookMarkLabelText; //Mr.chen, 09.10.2014, bookMark

@property Boolean isVerticalMode;
@property Boolean isLoadSnap;
@property Boolean isVerHorMode;
@property Boolean isLoadNavi;
@property int width;
@property int height;
@property float startDelay;

-(int) getPageIndex:(NSString *) pageid;
-(int) getPageSection:(NSString *) pageid;
-(NSMutableArray*) getSectionPages:(int) index;
-(NSMutableArray*) getSectionSnapshots:(int) index;
-(NSMutableArray*) getIndesignSectionSnapshots:(int) index  rootPath:(NSString *)rootPath;
-(NSMutableArray*) getAllPageId:(int) index rootPath:(NSString *)rootPath;
-(NSString*)       getSnapshot:(NSString*) pageid;
-(NSMutableArray*) getSectionSnapTitles:(int) index;
-(NSString*)       getSnapshotTitle:(NSString*) pageid;
-(HLPageEntity *)    getPageByID:(NSString *) pageid;
-(NSMutableArray*) getAllSectionPageId;

@end

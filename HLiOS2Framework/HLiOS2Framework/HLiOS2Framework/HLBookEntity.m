//
//  BookEntity.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HLBookEntity.h"
#import "HLSectionEntity.h"
#import "SnapshotEntity.h"
#import "HLPageEntity.h"
#import "HLPageDecoder.h"

@implementation HLBookEntity

@synthesize name;
@synthesize iconPath;
@synthesize account;
@synthesize rootPath;
@synthesize launchPage;
@synthesize pages;
@synthesize snapshots;
@synthesize sections;
@synthesize backgroundMusic;
@synthesize isVerticalMode;
@synthesize isVerHorMode;
@synthesize filpType;
@synthesize homepageid;
@synthesize homeBtn;
@synthesize snapBtn;
@synthesize bgMusicBtn;
@synthesize vbgMusicBtn;
@synthesize searchBtn;
@synthesize rightBtn;
@synthesize leftBtn;
@synthesize vhomeBtn;
@synthesize vsnapBtn;
@synthesize vrightBtn;
@synthesize vleftBtn;
@synthesize startDelay;
@synthesize bookType;
@synthesize navType;
@synthesize width;
@synthesize height;
@synthesize isFree, isLoadSnap;

@synthesize productID;
@synthesize referenceName;  //陈星宇
@synthesize isPaid;
@synthesize exitBtn;
@synthesize vexitBtn;

- (id)init
{
    self = [super init];
    if (self)
        
    {
        // Initialization code here.
        self.activePush = NO;
        self.pushID = @"";
        
        self.pages        = [[NSMutableArray alloc] initWithCapacity:10];
        self.snapshots    = [[NSMutableArray alloc] initWithCapacity:10];
        self.sections     = [[NSMutableArray alloc] initWithCapacity:10];
        self.isVerHorMode = NO;
        self.isLoadNavi = YES;
        self.isPaid = NO;//默认未支付 adward
        [self.pages release];
        [self.snapshots release];
        [self.sections release];
        self.startDelay = 2.0f;
        isLoadSnap = YES;
        
        // >>>>>  Mr.chen, 09.10.2014, bookMark
        self.showBookMark = YES;
        self.showBookMarkLabel = YES;
        self.hasBookMarkTag = YES;
        self.bookMarkLabelText = @"";
        
        HLBookEntityBookMarkPostion postion;
        postion.horPostion = HLBookEntityLabelHorPostionCenter;
        postion.verPostion = HLBookEntityLabelVerPostionCenter;
        postion.horGap = 0.0f;
        postion.verGap = 0.0f;
        
        self.bookMarkPostion = postion;
        // <<<<<
    }
    
    return self;
}

-(int) getPageIndex:(NSString *) pageid
{
    for (int i = 0; i < [self.pages count];i++ )
    {
        if ([(NSString*)[self.pages objectAtIndex:i] compare:pageid] == NSOrderedSame)
        {
            return i;
        }
    }
    return -1;
}

-(int) getPageSection:(NSString *) pageid
{
    for (int i = 0 ; i  < [self.sections count];i++)
    {
        HLSectionEntity *st = [self.sections objectAtIndex:i];
        if ([st isPageExist:pageid]) 
        {
            return i;
        }
    }
    return -1;
}

-(HLPageEntity *)  getPageByID:(NSString *) pageid
{
    for (int i = 0 ; i  < [self.sections count];i++)
    {
        HLSectionEntity *st = [self.sections objectAtIndex:i];
        if ([st getPageByID:pageid] != nil)
        {
            return [st getPageByID:pageid];
        }
    }
    return nil;
}

-(NSString*) getSnapshot:(NSString*) pageid
{
    for (int i = 0 ; i  < [self.snapshots count];i++)
    {
        SnapshotEntity *sn = [self.snapshots objectAtIndex:i];
        if ([pageid compare:sn.pageid]==NSOrderedSame) 
        {
            return sn.fileid;
        }
    }
    return nil;
}

-(NSString*) getSnapshotTitle:(NSString*) pageid
{
    for (int i = 0 ; i  < [self.snapshots count];i++)
    {
        SnapshotEntity *sn = [self.snapshots objectAtIndex:i];
        if ([pageid compare:sn.pageid]==NSOrderedSame) 
        {
            return sn.pageTitle;
        }
    }
    return nil;
}

-(NSMutableArray*) getSectionSnapTitles:(int) index
{
    NSMutableArray* sps = [[NSMutableArray alloc] initWithCapacity:15];
    NSMutableArray* pgs = ((HLSectionEntity*)[self.sections objectAtIndex:index]).pages;
    
    for (int i = 0 ; i < [pgs count]; i++)
    {
        NSString* pageid = [pgs objectAtIndex:i];
        NSString* pageTitle = [self getSnapshotTitle:pageid];
        if(pageTitle != nil)
        {
            [sps addObject:pageTitle];
        }
    }
    return [sps autorelease];
}

-(NSMutableArray*) getSectionPages:(int) index
{
    return ((HLSectionEntity*)[self.sections objectAtIndex:index]).pages;
}

-(NSMutableArray*) getSectionSnapshots:(int) index
{
    NSMutableArray* sps = [[NSMutableArray alloc] initWithCapacity:15];
    NSMutableArray* pgs = ((HLSectionEntity*)[self.sections objectAtIndex:index]).pages;
    for (int i = 0 ; i < [pgs count]; i++)
    {
        NSString* pageid = [pgs objectAtIndex:i];
        NSString* fileid = [self getSnapshot:pageid];
        if(fileid != nil)
        {
            [sps addObject:fileid];
        }
    }
    return [sps autorelease];
}

//获取所有页的截图 包括subpage子页
-(NSMutableArray*) getIndesignSectionSnapshots:(int) index rootPath:(NSString *)rootPath
{
    NSMutableArray* sps = [[NSMutableArray alloc] init];
    NSMutableArray* pgs = ((HLSectionEntity*)[self.sections objectAtIndex:index]).pages;
    for (int i = 0 ; i < [pgs count]; i++)
    {
        NSString* pageid = [pgs objectAtIndex:i];
        NSString* fileid = [self getSnapshot:pageid];
        HLPageEntity *pageEntity = [HLPageDecoder decode:pageid path:self.rootPath];
        NSMutableArray *childArr = [NSMutableArray array];
        if(fileid != nil)
        {
            [childArr addObject:fileid];
        }
        if (pageEntity.navPages.count > 0) {
            NSArray *childSnaps = pageEntity.navPages;
            
            for (int j = 0; j < childSnaps.count; j++) {
                pageid = [childSnaps objectAtIndex:j];
                fileid = [self getSnapshot:pageid];
                if(fileid != nil)
                {
                    [childArr addObject:fileid];
                }
            }
        }
        [sps addObject:childArr];
    }
    return [sps autorelease];
}

//获取所有页的id 包括subpage子页
-(NSMutableArray*) getAllPageId:(int) index rootPath:(NSString *)rootPath
{
    NSMutableArray* sps = [[NSMutableArray alloc] init];
    NSMutableArray* pgs = ((HLSectionEntity*)[self.sections objectAtIndex:index]).pages;
    for (int i = 0 ; i < [pgs count]; i++)
    {
        NSString* pageid = [pgs objectAtIndex:i];
        HLPageEntity *pageEntity = [HLPageDecoder decode:pageid path:self.rootPath];
        NSMutableArray *childArr = [NSMutableArray array];
        if(pageid != nil)
        {
            [childArr addObject:pageid];
        }
        if (pageEntity.navPages.count > 0) {
            NSArray *childSnaps = pageEntity.navPages;
            
            for (int j = 0; j < childSnaps.count; j++) {
                pageid = [childSnaps objectAtIndex:j];
                if(pageid != nil)
                {
                    [childArr addObject:pageid];
                }
            }
        }
        [sps addObject:childArr];
    }
    return [sps autorelease];
}

//获取所有section所有页的id 包括subpage子页
-(NSMutableArray*) getAllSectionPageId
{
    NSMutableArray* allId = [NSMutableArray array];
    for (int s = 0; s < self.sections.count; s++)
    {
        [allId addObject:[self getAllPageId:s rootPath:self.rootPath]];
    }
    
    return allId;
}

- (void)dealloc
{
    [self.adPosition release];
    [self.name release];
    [self.iconPath release];
    [self.account release];
    [self.rootPath release];
    [self.launchPage release];
    [self.backgroundMusic release];
    [self.filpType release];
    [self.homepageid release];
    [self.pages removeAllObjects];
    [self.pages release];
    [self.snapshots removeAllObjects];
    [self.snapshots release];
    [self.sections removeAllObjects];
    [self.sections release];
    [self.bookType release];
    [self.navType release];
    
    [self.productID release];
    [self.referenceName release];   
    [self.bookid release];      //陈星宇
    [self.deviceType release];
    
    self.homeBtn  = nil;
    self.snapBtn  = nil;
    self.rightBtn = nil;
    self.leftBtn  = nil;
    self.bgMusicBtn = nil;
    self.searchBtn = nil;
    self.exitBtn = nil;
    [super dealloc];
}

@end

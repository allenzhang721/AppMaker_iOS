//
//  PageDecoder.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-15.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "PageDecoder.h"
#import "PageEntity.h"
#import "TBXML.h"
#import "ContainerDecoder.h"
#import "XMLManager.h"

static XMLManager *xmlManager;

static NSString* const myDataPath = @"book.dat";
static NSString* const anotherDataPath = @"hash.dat";

@implementation PageDecoder

static float psx = 1.0;
static float psy = 1.0;
static float psx1 = 1.0;
static float psy1 = 1.0;
static bool  isVerHorMode = NO;
static bool  isAndriod = NO;
static float bookWidth = 1.0;
static float bookHeight = 1.0;

+(void) close
{
    xmlManager = nil;
}

+(void) setSX:(float) sx;
{
    psx = sx;
}

+(void) setSY:(float) sy;
{
    psy = sy;
}

+(void) setSX1:(float) sx
{
    psx1 = sx;
}
+(void) setSY1:(float) sy
{
    psy1 = sy;
}

+(void) setHorVerMode:(bool) value
{
    isVerHorMode = value;
}

+(void) setAndroidType:(bool) value
{
    isAndriod = value;
}
+(void) setBookWidth:(float) value
{
    bookWidth = value;
}
+(void) setBookHeight:(float) value
{
    bookHeight = value;
}
+(float) getSX
{
    return psx;
}

+(float) getSY;
{
    return psy;
}

+(void)initXmlManager:(NSString*)rootpath
{
    NSString *path = [rootpath stringByAppendingPathComponent:myDataPath];
//    NSString *anotherPath = [rootpath stringByAppendingString:anotherDataPath];
    NSData *myData = [[NSData alloc] initWithContentsOfFile:path];
//    NSData *anotherData = [[NSData alloc] initWithContentsOfFile:anotherPath];
    NSRange range = NSMakeRange(0, 4);
    NSData *data = [myData subdataWithRange:range];
    uint32_t value = CFSwapInt32BigToHost(*(uint32_t*)([data bytes]));
    range.location = 4;
    range.length = value;
    data = [myData subdataWithRange:range];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    xmlManager = [[XMLManager alloc] init];
    xmlManager.data = myData;
//    xmlManager.hData = anotherData;
    [myData release];
//    [anotherData release];
    xmlManager.offset = value + 4;
    [xmlManager decode:str];
    [str release];
}

+(void) load:(PageEntity *)entity path:(NSString *)path
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (!xmlManager)
    {
        [PageDecoder initXmlManager:path];
    }
    NSString *data      = [xmlManager getStringByID:entity.entityid];
    TBXML* tbxml        = [[[TBXML alloc] initWithXMLString:data error:nil] autorelease];
    TBXMLElement *root  = tbxml.rootXMLElement;
    if (root)
	{
        TBXMLElement *containers = [TBXML childElementNamed:@"Containers" parentElement:root];
		TBXMLElement *container  = [TBXML childElementNamed:@"Container"  parentElement:containers];
        while (container != nil)
        {
            ContainerEntity *containerEntity;
            if (entity.isVerticalPageType == YES)
            {
                if (isVerHorMode == YES)
                {
                    containerEntity  = [ContainerDecoder decode:container sx:psx1 sy:psy1];
                }
                else
                {
                    containerEntity  = [ContainerDecoder decode:container sx:psx sy:psy];
                }
            }
            else
            {
                containerEntity  = [ContainerDecoder decode: container sx:psx sy:psy];
            }
            [entity.containers addObject:containerEntity];
            [containerEntity release];
            container = [TBXML nextSiblingNamed:@"Container" searchFromElement:container];
        }
        TBXMLElement *background = [TBXML childElementNamed:@"Background" parentElement:root];
        if(background != nil)
        {
            TBXMLElement *backgroundContainer = [TBXML childElementNamed:@"Container" parentElement:background];
            ContainerEntity *containerEntity = [ContainerDecoder decode:backgroundContainer sx:psx sy:psy];
            entity.background = containerEntity;
            [containerEntity release];
        }
        TBXMLElement *playSequence = [TBXML childElementNamed:@"PlaySequence" parentElement:root];
        if (playSequence != nil)
        {
            TBXMLElement *group   = [TBXML childElementNamed:@"Group"  parentElement:playSequence];
            while (group != nil)
            {
                NSMutableArray* gp = [[NSMutableArray alloc] initWithCapacity:10];
                TBXMLElement *cid   = [TBXML childElementNamed:@"ID"   parentElement:group];
                while (cid != nil)
                {
                    NSString* sid =  [TBXML textForElement:cid];
                    [gp addObject:sid];
                    cid =  [TBXML nextSiblingNamed:@"ID" searchFromElement:cid];
                }
                [entity.groups addObject:gp];
                [gp release];
                group = [TBXML nextSiblingNamed:@"Group" searchFromElement:group];
            }
        }
        TBXMLElement *playSequenceDelay = [TBXML childElementNamed:@"PlaySequenceDelay" parentElement:root];
        if(playSequenceDelay != nil)
        {
            TBXMLElement *delay   = [TBXML childElementNamed:@"Delay"  parentElement:playSequenceDelay];
            while (delay != nil)
            {
                NSString *sdelay = [TBXML textForElement:delay];
                NSNumber *delayTime = [NSNumber numberWithFloat:[sdelay floatValue]];
                [entity.groupDelay addObject:delayTime];
                delay = [TBXML nextSiblingNamed:@"Delay" searchFromElement:delay];
            }
        }
    }
    entity.isLoaded = YES;
    [pool release];
}

+(PageEntity *) decode:(NSString *)pageid path:(NSString *)path
{
    //    if (pageid != nil && ![@"" isEqualToString:pageid])
    //    {
    
    PageEntity *entity  = [[[PageEntity alloc] init] autorelease];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (!xmlManager)
    {
        [PageDecoder initXmlManager:path];
    }
    NSString *data      = [xmlManager getStringByID:pageid];
    TBXML* tbxml        = [[[TBXML alloc] initWithXMLString:data error:nil] autorelease];
    TBXMLElement *root  = tbxml.rootXMLElement;
    if (root)
	{
        entity.entityid	 = [TBXML textForElement:[TBXML childElementNamed:@"ID" parentElement:root]];
		entity.title	 = [TBXML textForElement:[TBXML childElementNamed:@"Title" parentElement:root]];
		entity.description  = [TBXML textForElement:[TBXML childElementNamed:@"Description" parentElement:root]];
        TBXMLElement *snapxml = [TBXML childElementNamed:@"SnapID" parentElement:root];
        if (snapxml)
        {
            NSString *snapID  = [TBXML textForElement:snapxml];
            if (snapID && ![snapID isEqualToString:@""])
            {
                entity.isCached = YES;
                entity.cacheImageID = snapID;
            }
            else
            {
                entity.isCached = NO;
            }
        }
        
        if ([TBXML childElementNamed:@"IsLoadSnap" parentElement:root])
        {
            NSString *isUseSlide = [TBXML textForElement:[TBXML childElementNamed:@"IsLoadSnap" parentElement:root]];
            if ([isUseSlide compare:@"false"] == NSOrderedSame)
            {
                entity.isUseSlide = YES;
                entity.isCached = NO;
            }
        }
        
        if([TBXML childElementNamed:@"EnablePageTurnByHand" parentElement:root] != nil)
        {
            entity.enableGesture = [[TBXML textForElement:[TBXML childElementNamed:@"EnablePageTurnByHand" parentElement:root]] boolValue];
        }
        if ([TBXML childElementNamed:@"Type" parentElement:root] != nil)
        {
            NSString *pageType = [TBXML textForElement:[TBXML childElementNamed:@"Type" parentElement:root]];
            if([pageType compare:@"PAGE_TYPE_HOR"] == NSOrderedSame)
            {
                entity.isVerticalPageType = NO;
            }
            else
            {
                entity.isVerticalPageType = YES;
            }
        }
        
        NSString *width  = [TBXML textForElement:[TBXML childElementNamed:@"Width" parentElement:root]];
		NSString *height = [TBXML textForElement:[TBXML childElementNamed:@"Height" parentElement:root]];
        entity.contentWidth = [width intValue];
        entity.contentHeight = [height intValue];
        float screamWidth = [UIScreen mainScreen].bounds.size.height;
        float screamHeight = [UIScreen mainScreen].bounds.size.width;
        
        if (!isAndriod)
        {
            //            if([width isEqualToString:@""] || [height isEqualToString:@""]) //13-12-30
            //            {
            
            //            >>>>>  Mr.chen , 1.23  是否该这样？
            if([width isEqualToString:@""] || [height isEqualToString:@""]) //13-12-30
            {
                if (entity.contentWidth == 1024)
                {
                    height = @"768";
                }
                else if (entity.contentWidth == 768)
                {
                    height = @"1024";
                }
                else if (entity.contentWidth == 320)
                {
                    height = [NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.height];
                }
                else if (entity.contentWidth == 640)
                {
                    height = [NSString stringWithFormat:@"%f", [UIScreen mainScreen].bounds.size.height * 2] ;
                }
                else if (entity.contentWidth == 480 || entity.contentWidth == 568)
                {
                    height = @"320";
                }
                else if (entity.contentWidth == 960 || entity.contentWidth == 1136)
                {
                    height = @"640";
                }
            }
            //            <<<<< Mr.chen , 1.23
            //            }
            
            if (isVerHorMode == YES)
            {
                if (entity.isVerticalPageType == YES)
                {
                    entity.width       = [NSNumber numberWithFloat:bookHeight*psx1];//[NSNumber numberWithFloat:[width floatValue]*psx1];
                    entity.height      = [NSNumber numberWithFloat:bookWidth*psy1];//[NSNumber numberWithFloat:[height floatValue]*psy1];
                    
                    entity.contentWidth = entity.contentWidth*psx1;
                    entity.contentHeight = entity.contentHeight*psy1;
                }
                else
                {
                    entity.width       = [NSNumber numberWithFloat:bookWidth*psx];//[NSNumber numberWithFloat:[width floatValue]*psx];
                    entity.height      = [NSNumber numberWithFloat:bookHeight*psy];//[NSNumber numberWithFloat:[height floatValue]*psy];
                    entity.contentWidth = entity.contentWidth*psx;
                    entity.contentHeight = entity.contentHeight*psy;
                }
            }
            else
            {
                entity.width       = [NSNumber numberWithFloat:bookWidth*psx];//[NSNumber numberWithFloat:[width floatValue]*psx];
                entity.height      = [NSNumber numberWithFloat:bookHeight*psy];//[NSNumber numberWithFloat:[height floatValue]*psy];
                entity.contentWidth = entity.contentWidth*psx;
                entity.contentHeight = entity.contentHeight*psy;
            }
        }
        else
        {
            
            if (isVerHorMode == YES)
            {
                if (entity.isVerticalPageType == YES)
                {
                    entity.width       = [NSNumber numberWithFloat:bookHeight*psx1];//[NSNumber numberWithFloat:[width floatValue]*psx1];
                    entity.height      = [NSNumber numberWithFloat:bookWidth*psy1];//[NSNumber numberWithFloat:[height floatValue]*psy1];
                    
                    entity.contentWidth = entity.contentWidth*psx1;
                    entity.contentHeight = entity.contentHeight*psy1;
                }
                else
                {
                    entity.width       = [NSNumber numberWithFloat:bookWidth*psx];//[NSNumber numberWithFloat:[width floatValue]*psx];
                    entity.height      = [NSNumber numberWithFloat:bookHeight*psy];//[NSNumber numberWithFloat:[height floatValue]*psy];
                    entity.contentWidth = entity.contentWidth*psx;
                    entity.contentHeight = entity.contentHeight*psy;
                }
            }
            else
            {
                entity.width       = [NSNumber numberWithFloat:bookWidth*psx];//[NSNumber numberWithFloat:[width floatValue]*psx];
                entity.height      = [NSNumber numberWithFloat:bookHeight*psy];//[NSNumber numberWithFloat:[height floatValue]*psy];
                entity.contentWidth = entity.contentWidth*psx;
                entity.contentHeight = entity.contentHeight*psy;
            }
//            float scrWidth = 0;
//            float scrHeight = 0;
//            
//            
//            if (isVerHorMode == YES)
//            {
//                if (entity.isVerticalPageType == YES)
//                {
//                    entity.width       = [NSNumber numberWithFloat:bookHeight];
//                    entity.height      = [NSNumber numberWithFloat:bookWidth];
//                    scrWidth           = screamWidth;
//                    scrHeight          = screamHeight;
//                }
//                else
//                {
//                    entity.width       = [NSNumber numberWithFloat:bookWidth];
//                    entity.height      = [NSNumber numberWithFloat:bookHeight];
//                    scrWidth           = screamHeight;
//                    scrHeight          = screamWidth;
//                }
//            }
//            else
//            {
//                entity.width       = [NSNumber numberWithFloat:bookWidth];
//                entity.height      = [NSNumber numberWithFloat:bookHeight];
//                if(bookWidth  >  bookHeight)
//                {
//                    scrWidth           = screamWidth;
//                    scrHeight          = screamHeight;
//                }
//                else
//                {
//                    scrWidth           = screamHeight;
//                    scrHeight          = screamWidth;
//                }
//            }
//            
//            if ([entity.width floatValue]/ [entity.height floatValue]> scrWidth / scrHeight)
//            {
//                entity.height = [NSNumber numberWithFloat:[entity.width floatValue] / scrWidth * scrHeight];
//                entity.width = [NSNumber numberWithFloat:scrWidth];
//                psx = scrWidth / (float) entity.contentWidth;
//                psy = psx;
//                psx1 = psx;
//                psy1 = psx;
//            }
//            else
//            {
//                entity.width = [NSNumber numberWithFloat:scrHeight / [entity.height floatValue] * scrWidth];
//                entity.height = [NSNumber numberWithFloat:scrHeight];
//                psx = scrHeight / (float) entity.contentHeight;
//                psy = psx;
//                psx1 = psx;
//                psy1 = psx;
//            }
//            entity.contentWidth = entity.contentWidth*psx1;
//            entity.contentHeight = entity.contentHeight*psy1;
        }
//        NSLog(@"height:%@ width:%@   winH:%d winW:%d",entity.height,entity.width,entity.contentHeight,entity.contentWidth);
        
        
        if([TBXML childElementNamed:@"LinkPageID" parentElement:root] != nil)
        {
            NSString *linkPageID = [TBXML textForElement:[TBXML childElementNamed:@"LinkPageID" parentElement:root]];
            entity.linkPageID    = linkPageID;
        }
        
        NSString *enableNavigation =  [TBXML textForElement:[TBXML childElementNamed:@"EnableNavigation" parentElement:root]];
        if([enableNavigation compare:@"false"] == NSOrderedSame)
        {
            entity.enbableNavigation = NO;
        }
        else
        {
            entity.enbableNavigation = YES;
        }
        
        //陈星宇
        if ([TBXML childElementNamed:@"IsNeedPay" parentElement:root] != nil)   //判断
        {
            NSString *isNeedPay = [TBXML textForElement:[TBXML childElementNamed:@"IsNeedPay" parentElement:root]];
            if(isNeedPay != nil)
            {
                if ([isNeedPay compare:@"false"] == NSOrderedSame)
                {
                    entity.isNeedPay = NO;
                }
                else
                {
                    entity.isNeedPay = YES;
                }
            }
        }
        //陈星宇
        
        if ([TBXML childElementNamed:@"IsGroupPlay" parentElement:root] != nil)
        {
             NSString *isGroupPlay = [TBXML textForElement:[TBXML childElementNamed:@"IsGroupPlay" parentElement:root]];
            if(isGroupPlay != nil)
            {
                if([isGroupPlay compare:@"false"] == NSOrderedSame)
                {
                    entity.isGroupPlay = NO;
                }
                else
                {
                    entity.isGroupPlay = YES;
                }

            }
        }
        else
        {
            entity.isGroupPlay = NO;
        }
        TBXMLElement *navPages = [TBXML childElementNamed:@"NavePageIds" parentElement:root];
        if (navPages != nil)
        {
            TBXMLElement *navPage = [TBXML childElementNamed:@"NavePageId" parentElement:navPages];
            while (navPage != nil)
            {
                NSString *np = [TBXML textForElement:navPage];
                [entity.navPages addObject:np];
                navPage = [TBXML nextSiblingNamed:@"NavePageId" searchFromElement:navPage];
            }
        }
        
        
        //added by Adward 13-11-27 页面翻转效果 ,记得加保护
        if ([TBXML childElementNamed:@"PageChangeEffectType" parentElement:root] != nil)
        {
            TBXMLElement *pageChangeEffectType = [TBXML childElementNamed:@"PageChangeEffectType" parentElement:root];
            NSString *aniTypeStr = [TBXML textForElement:pageChangeEffectType];
            HLPageChangeAnimationType type = pageChangeAnimationTypeNon;
            if ([aniTypeStr isEqualToString:@"transitionFade"])
            {
                type = pageChangeAnimationTypeFade;
            }
            else if ([aniTypeStr isEqualToString:@"transitionPush"])
            {
                type = pageChangeAnimationTypePush;
            }
            else if ([aniTypeStr isEqualToString:@"transitionReveal"])
            {
                type = pageChangeAnimationTypeReveal;
            }
            else if ([aniTypeStr isEqualToString:@"transitionMoveIn"])
            {
                type = pageChangeAnimationTypeMoveIn;
            }
            else if ([aniTypeStr isEqualToString:@"cubeEffect"])
            {
                type = pageChangeAnimationTypeCubeEffect;
            }
            else if ([aniTypeStr isEqualToString:@"suckEffect"])
            {
                type = pageChangeAnimationTypeSuckEffect;
            }
            else if ([aniTypeStr isEqualToString:@"flipEffect"])
            {
                type = pageChangeAnimationTypeFlipEffect;
            }
            else if ([aniTypeStr isEqualToString:@"rippleEffect"])
            {
                type = pageChangeAnimationTypeRippleEffect;
            }
            else if ([aniTypeStr isEqualToString:@"pageCurl"])
            {
                type = pageChangeAnimationTypePageCurl;
            }
            else if ([aniTypeStr isEqualToString:@"pageUnCurl"])
            {
                type = pageChangeAnimationTypePageUnCul;
            }
            
            entity.animationType = [NSString stringWithFormat:@"%d",type];
        }
        
        
        if ([TBXML childElementNamed:@"PageChangeEffectDir" parentElement:root] != nil)
        {
            TBXMLElement *pageChangeEffectDir = [TBXML childElementNamed:@"PageChangeEffectDir" parentElement:root];
            NSString *dirString = [TBXML textForElement:pageChangeEffectDir];
            
            HLPageChangeAnimationDir dir = pageChangeHLAnimationDirNon;
            if ([dirString isEqualToString:@"left"])
            {
                dir = pageChangeHLAnimationDirLeft;
            }
            else if ([dirString isEqualToString:@"right"])
            {
                dir = pageChangeHLAnimationDirRight;
            }
            else if ([dirString isEqualToString:@"up"])
            {
                dir = pageChangeHLAnimationDirDown;
            }
            else if ([dirString isEqualToString:@"down"])
            {
                dir = pageChangeHLAnimationDirUp;
            }
            else
            {
                dir = pageChangeHLAnimationDirNon;
            }
            entity.animationDir = [NSString stringWithFormat:@"%d",dir];
        }
        
        if ([TBXML childElementNamed:@"PageChangeEffectDuration" parentElement:root] != nil)
        {
            TBXMLElement *pageChangeEffectDuration = [TBXML childElementNamed:@"PageChangeEffectDuration" parentElement:root];
            entity.animationDuration = [TBXML textForElement:pageChangeEffectDuration];
            entity.animationDuration = ([entity.animationDuration intValue] > 0) ? entity.animationDuration : [NSString stringWithFormat:@"%d",500];//adward 2.20 规避
        }
        
//        >>>>>    12.27，覆盖公共页
        /*
         1、
         "<State>" + page.state + "</State>"
         判断他是不是公共页面，    当为PAGE_STATIC_STATE ;  为公共页面。  当是PAGE_NORMAL_STATE 时候为普通页;
         2、
         "<BeCoveredPageID>" + page.beCoveredPageID + "</BeCoveredPageID>"
         记录覆盖此页的公共页，只有当页面为普通页面时才有值，默认为“”
         3、
         在xml中我加了一段字段
         "<CoverPageIds>";
         for each(var coverPageID:String in page.coverPages)
         {
         "<CoverPageId>";
         coverPageID;
         "</CoverPageId>";
         }
         "</CoverPageIds>";
         记录此页公共页覆盖的普通页， 只有当页面为公共页的时候才有值，默认为“”
         */
        
        if ([TBXML childElementNamed:@"State" parentElement:root] != Nil)
        {
            TBXMLElement *state = [TBXML childElementNamed:@"State" parentElement:root];
            NSString *stateString = [TBXML textForElement:state];
            entity.stateString = stateString;
            
            if ([stateString compare:@"PAGE_STATIC_STATE"] == NSOrderedSame) {
                
                entity.state = pageEntityStatePublic;
                
            } else if ([stateString compare:@"PAGE_NORMAL_STATE"] == NSOrderedSame) {
                
                entity.state = pageEntityStateNormal;
            }
            
        }
        
        if ([TBXML childElementNamed:@"BeCoveredPageID" parentElement:root] != nil)
        {
            TBXMLElement *beCoveredPageID = [TBXML childElementNamed:@"BeCoveredPageID" parentElement:root];
            entity.beCoveredPageID = [TBXML textForElement:beCoveredPageID];
        }
        
        if ([TBXML childElementNamed:@"CoverPageIds" parentElement:root])
        {
            TBXMLElement *coverPageIds = [TBXML childElementNamed:@"CoverPageIds" parentElement:root];
        
            if ([TBXML childElementNamed:@"CoverPageId" parentElement:coverPageIds])
            {
                TBXMLElement *coverPageId = [TBXML childElementNamed:@"CoverPageId" parentElement:coverPageIds];
                
                while (coverPageId != nil)
                {
                    NSString *coverpageIdString = [TBXML textForElement:coverPageId];
                    [entity.CoverPageIds addObject:coverpageIdString];
                    [coverpageIdString release];
                    coverPageId = [TBXML nextSiblingNamed:@"CoverPageId" searchFromElement:coverPageId];
                }
            }
        }
//        <<<<<

    }
    [pool release];
    return entity;
//    }
//    else
//    {
//        return nil;
//    }
}
@end
